#include "gamepad_plugin.h"

#include <fcntl.h>
#include <linux/joystick.h>
#include <sys/ioctl.h>
#include <unistd.h>

#include <cstring>

#define MAX_JOYSTICKS 4
#define MAX_AXES 16
#define MAX_BUTTONS 32

struct JoystickState {
  int fd = -1;
  int16_t axes[MAX_AXES] = {};
  uint8_t buttons[MAX_BUTTONS] = {};
  uint8_t num_axes = 0;
  uint8_t num_buttons = 0;
};

static JoystickState g_joysticks[MAX_JOYSTICKS];

static void open_joystick(int i) {
  char path[32];
  snprintf(path, sizeof(path), "/dev/input/js%d", i);
  int fd = open(path, O_RDONLY | O_NONBLOCK);
  if (fd < 0) return;
  g_joysticks[i].fd = fd;
  ioctl(fd, JSIOCGAXES, &g_joysticks[i].num_axes);
  ioctl(fd, JSIOCGBUTTONS, &g_joysticks[i].num_buttons);
  // Drain synthetic init events so we start with a clean slate.
  struct js_event e;
  while (read(fd, &e, sizeof(e)) > 0) {
    if (e.type & JS_EVENT_AXIS) g_joysticks[i].axes[e.number] = e.value;
    if (e.type & JS_EVENT_BUTTON) g_joysticks[i].buttons[e.number] = e.value;
  }
}

static void read_pending(JoystickState& js) {
  struct js_event e;
  while (read(js.fd, &e, sizeof(e)) > 0) {
    uint8_t idx = e.number;
    if ((e.type & JS_EVENT_AXIS) && idx < MAX_AXES)
      js.axes[idx] = e.value;
    if ((e.type & JS_EVENT_BUTTON) && idx < MAX_BUTTONS)
      js.buttons[idx] = static_cast<uint8_t>(e.value);
  }
}

static double normalize_axis(int16_t v) {
  if (v >= 0) return v / 32767.0;
  return v / 32768.0;
}

// Trigger axes arrive as -32767..32767; map to 0..1.
static double normalize_trigger(int16_t v) {
  return (v + 32767) / 65534.0;
}

static FlValue* build_controller_map(const JoystickState& js) {
  g_autoptr(FlValue) map = fl_value_new_map();

  double lx = normalize_axis(js.axes[0]);
  double ly = normalize_axis(js.axes[1]);  // JS Y already inverted (up = negative), no extra negation
  double lt = normalize_trigger(js.axes[2]);
  double rx = normalize_axis(js.axes[3]);
  double ry = normalize_axis(js.axes[4]);
  double rt = normalize_trigger(js.axes[5]);
  int16_t dpx = (js.num_axes > 6) ? js.axes[6] : 0;
  int16_t dpy = (js.num_axes > 7) ? js.axes[7] : 0;

  fl_value_set_string_take(map, "lx", fl_value_new_float(lx));
  fl_value_set_string_take(map, "ly", fl_value_new_float(ly));
  fl_value_set_string_take(map, "rx", fl_value_new_float(rx));
  fl_value_set_string_take(map, "ry", fl_value_new_float(ry));
  fl_value_set_string_take(map, "lt", fl_value_new_float(lt));
  fl_value_set_string_take(map, "rt", fl_value_new_float(rt));

  fl_value_set_string_take(map, "a",     fl_value_new_bool(js.num_buttons > 0 && js.buttons[0]));
  fl_value_set_string_take(map, "b",     fl_value_new_bool(js.num_buttons > 1 && js.buttons[1]));
  fl_value_set_string_take(map, "x",     fl_value_new_bool(js.num_buttons > 2 && js.buttons[2]));
  fl_value_set_string_take(map, "y",     fl_value_new_bool(js.num_buttons > 3 && js.buttons[3]));
  fl_value_set_string_take(map, "lb",    fl_value_new_bool(js.num_buttons > 4 && js.buttons[4]));
  fl_value_set_string_take(map, "rb",    fl_value_new_bool(js.num_buttons > 5 && js.buttons[5]));
  fl_value_set_string_take(map, "back",  fl_value_new_bool(js.num_buttons > 6 && js.buttons[6]));
  fl_value_set_string_take(map, "start", fl_value_new_bool(js.num_buttons > 7 && js.buttons[7]));

  fl_value_set_string_take(map, "dl", fl_value_new_bool(dpx < -16384));
  fl_value_set_string_take(map, "dr", fl_value_new_bool(dpx >  16384));
  fl_value_set_string_take(map, "du", fl_value_new_bool(dpy < -16384));
  fl_value_set_string_take(map, "dd", fl_value_new_bool(dpy >  16384));

  return fl_value_ref(map);
}

static void method_call_cb(FlMethodChannel* /*channel*/,
                           FlMethodCall* method_call,
                           gpointer /*user_data*/) {
  if (strcmp(fl_method_call_get_name(method_call), "poll") != 0) {
    fl_method_call_respond_not_implemented(method_call, nullptr);
    return;
  }

  // Re-try closed slots for hot-plug.
  for (int i = 0; i < MAX_JOYSTICKS; i++) {
    if (g_joysticks[i].fd < 0) open_joystick(i);
  }

  g_autoptr(FlValue) list = fl_value_new_list();
  for (int i = 0; i < MAX_JOYSTICKS; i++) {
    if (g_joysticks[i].fd < 0) continue;
    read_pending(g_joysticks[i]);
    FlValue* pad = build_controller_map(g_joysticks[i]);
    fl_value_append_take(list, pad);
  }

  g_autoptr(FlMethodSuccessResponse) response =
      fl_method_success_response_new(list);
  fl_method_call_respond(method_call, FL_METHOD_RESPONSE(response), nullptr);
}

void gamepad_plugin_register_with_registrar(FlPluginRegistrar* registrar) {
  g_autoptr(FlStandardMethodCodec) codec = fl_standard_method_codec_new();
  g_autoptr(FlMethodChannel) channel = fl_method_channel_new(
      fl_plugin_registrar_get_messenger(registrar),
      "com.tyrian/gamepad",
      FL_METHOD_CODEC(codec));
  fl_method_channel_set_method_call_handler(
      channel, method_call_cb, nullptr, nullptr);
}
