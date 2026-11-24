// Complete-the-set pricing: pick which "all items" product to offer.
//
// The stores cannot price one product per customer, so the bundle exists as a
// ladder of products that unlock identical content at falling fixed prices.
// Each step has a threshold: how many paid items the customer must already
// own for that step to be offered. Step 0 is the full price at threshold 0.
//
// Pure Dart, no imports, no app types: the same file (and its table test)
// is copied into every Ol1n app that sells a bundle. Keep it that way, so the
// copies stay identical until the code moves into a shared package.

/// One rung of the ladder: offered once the customer owns at least
/// [threshold] paid items.
typedef SetLadderStep = ({int threshold, String productId});

/// The product id to offer a customer who owns [owned] paid items, or null
/// when no step applies (an empty ladder, or one whose lowest threshold is
/// above [owned]).
///
/// [steps] must be ordered by ascending threshold. The highest step whose
/// threshold [owned] meets wins, so owning more items than the last threshold
/// keeps offering the last step: the bundle also covers future items, so it
/// stays worth offering even to someone who owns everything today.
String? setLadderOffer(int owned, List<SetLadderStep> steps) {
  final i = setLadderIndex(owned, steps);
  return i < 0 ? null : steps[i].productId;
}

/// Index of the step [setLadderOffer] picks, or -1 when none applies.
/// Step 0 is the full price; any index above 0 is a credited price.
int setLadderIndex(int owned, List<SetLadderStep> steps) {
  var index = -1;
  for (var i = 0; i < steps.length; i++) {
    if (steps[i].threshold > owned) break;
    index = i;
  }
  return index;
}
