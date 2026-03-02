Attribute VB_Name = "GdiPlus"
Option Explicit


Public Const LF_FACESIZEW As Long = LF_FACESIZE * 2

Public Const FlatnessDefault As Single = 1# / 4#

Public Const AlphaShift = 24
Public Const RedShift = 16
Public Const GreenShift = 8
Public Const BlueShift = 0

Public Const AlphaMask = &HFF000000
Public Const RedMask = &HFF0000
Public Const GreenMask = &HFF00
Public Const BlueMask = &HFF

' ----------------------------------------------------------------------------------------------------------------------

Public Type POINTL
    x As Long
    y As Long
End Type

Public Type POINTF
    x As Single
    y As Single
End Type

Public Type RECTL
    Left As Long
    Top As Long
    Right As Long
    Bottom As Long
End Type

Public Type RECTF
    Left As Single
    Top As Single
    Right As Single
    Bottom As Single
End Type

Public Type COLORBYTES
    BlueByte As Byte
    GreenByte As Byte
    RedByte As Byte
    AlphaByte As Byte
End Type

Public Type COLORLONG
    longval As Long
End Type


' Enums ------------------------------------------------------------------

Public Type GdiplusStartupInput
    GdiplusVersion As Long
    DebugEventCallback As Long
    SuppressBackgroundThread As Long
    SuppressExternalCodecs As Long
End Type

Public Enum GpStatus
    Ok = 0
    GenericError = 1
    InvalidParameter = 2
    OutOfMemory = 3
    ObjectBusy = 4
    InsufficientBuffer = 5
    NotImplemented = 6
    Win32Error = 7
    WrongState = 8
    Aborted = 9
    FileNotFound = 10
    ValueOverflow = 11
    AccessDenied = 12
    UnknownImageFormat = 13
    FontFamilyNotFound = 14
    FontStyleNotFound = 15
    NotTrueTypeFont = 16
    UnsupportedGdiplusVersion = 17
    GdiplusNotInitialized = 18
    PropertyNotFound = 19
    PropertyNotSupported = 20
End Enum

Public Enum GpUnit
    UnitWorld = 0           ' World coordinate (non-physical unit)
    UnitDisplay = 1         ' Variable - for PageTransform only
    UnitPixel = 2           ' Each unit is device pixel
    UnitPoint = 3           ' Each unit is printer's point, or 1/72 inch.
    UnitInch = 4
    UnitDocument = 5        ' Each unit is 1/300 inch.
    UnitMillimeter = 6
End Enum

Public Enum CompositingMode
    CompositingModeSourceOver = 0
    CompositinModeSourceCopy = 1
End Enum

Public Enum QualityMode
    QualityModeInvalid = -1
    QualityModeDefault = 0
    QualityModeLow = 1
    QualityModeHigh = 2
End Enum

Public Enum FlushIntention
    FlushIntentionFlush = 0
    FlushIntentionSync = 1
End Enum

Public Enum BrushType
    BrushTypeSolidColor = 0
    BrushTypeHatchFill = 1
    BrushTypeTextureFill = 2
    BrushTypePathGradient = 3
    BrushTypeLinearGradient = 4
End Enum

Public Enum WrapMode
    WrapModeTile = 0
    WrapModeTileFilpX = 1
    WrapModeTileFlipY = 2
    WrapModeTileFlipXY = 3
    WrapModeClamp = 4
End Enum

Public Enum MatrixOrder
    MatrixOrderPrepend = 0
    MatrixOrderAppend = 1
End Enum

Public Enum FillMode
    FillModeAlternate = 0
    FillModeWinding = 1
End Enum

' ----------------------------------------------------------------------------------------------------------------------

Public Declare Function GdipAddPathEllipse Lib "gdiplus" (ByVal Path As Long, ByVal x As Single, ByVal y As Single, _
        ByVal w As Single, ByVal h As Single) As GpStatus
Public Declare Function GdipAddPathLine Lib "gdiplus" (ByVal Path As Long, ByVal x1 As Single, ByVal y1 As Single, _
        ByVal x2 As Single, ByVal y2 As Single) As GpStatus
Public Declare Function GdipAddPathRectangle Lib "gdiplus" (ByVal Path As Long, ByVal x As Single, ByVal y As Single, _
        ByVal w As Single, ByVal h As Single) As GpStatus
Public Declare Function GdipAlloc Lib "gdiplus" (ByVal size As Long) As Long
Public Declare Function GdipBitmapGetPixel Lib "gdiplus" (ByVal Bitmap As Long, ByVal x As Long, ByVal y As Long, _
        color As Long) As GpStatus
Public Declare Function GdipBitmapSetPixel Lib "gdiplus" (ByVal Bitmap As Long, ByVal x As Long, ByVal y As Long, _
        ByVal color As Long) As GpStatus
Public Declare Function GdipClonePath Lib "gdiplus" (ByVal Path As Long, cloned As Long) As GpStatus
Public Declare Function GdipClosePathFigure Lib "gdiplus" (ByVal Path As Long) As GpStatus
Public Declare Function GdipCreateBitmapFromFile Lib "gdiplus" (ByVal filename As String, Bitmap As Long) As GpStatus 'long
Public Declare Function GdipCreateBitmapFromGraphics Lib "gdiplus" (ByVal width As Long, ByVal height As Long, _
        ByVal graphics As Long, Bitmap As Long) As GpStatus
Public Declare Function GdipCreateBitmapFromHBITMAP Lib "gdiplus" (ByVal hbm As Long, ByVal hpal As Long, Bitmap As Long) _
        As GpStatus
Public Declare Function GdipCreateFromHDC Lib "gdiplus" (ByVal hdc As Long, graphics As Long) As GpStatus
Public Declare Function GdipCreateFromHWND Lib "gdiplus" (ByVal hwnd As Long, graphics As Long) As GpStatus
Public Declare Function GdipCreateHBITMAPFromBitmap Lib "gdiplus" (ByVal Bitmap As Long, hBitmap As Long, _
        ByVal background As Long) As GpStatus
Public Declare Function GdipCreateMatrix Lib "gdiplus" (matrix As Long) As GpStatus
Public Declare Function GdipCreateMatrix2 Lib "gdiplus" (ByVal m11 As Single, ByVal m12 As Single, ByVal m21 As Single, _
        ByVal m22 As Single, ByVal dx As Single, ByVal dy As Single, matrix As Long) As GpStatus
Public Declare Function GdipCreatePath Lib "gdiplus" (ByVal brushmode As FillMode, Path As Long) As GpStatus
Public Declare Function GdipCreatePathGradient Lib "gdiplus" (points As POINTF, ByVal count As Long, _
        ByVal wrapMd As WrapMode, polyGrad As Long) As GpStatus
Public Declare Function GdipCreatePathGradientFromPath Lib "gdiplus" (ByVal Path As Long, polyGrad As Long) As GpStatus
Public Declare Function GdipCreatePen1 Lib "gdiplus" (ByVal color As Long, ByVal width As Single, ByVal unit As GpUnit, _
        pen As Long) As GpStatus
Public Declare Function GdipCreatePen2 Lib "gdiplus" (ByVal brush As Long, ByVal width As Single, ByVal unit As GpUnit, _
        pen As Long) As GpStatus
Public Declare Function GdipCreateSolidFill Lib "gdiplus" (ByVal argb As Long, brush As Long) As GpStatus
Public Declare Function GdipCreateTexture Lib "gdiplus" (ByVal Image As Long, ByVal wrapMd As WrapMode, Texture As Long) _
        As GpStatus
Public Declare Function GdipDeleteGraphics Lib "gdiplus" (ByVal graphics As Long) As GpStatus
Public Declare Function GdipDeleteMatrix Lib "gdiplus" (ByVal matrix As Long) As GpStatus
Public Declare Function GdipDeletePath Lib "gdiplus" (ByVal Path As Long) As GpStatus
Public Declare Function GdipDisposeImage Lib "gdiplus" (ByVal Image As Long) As GpStatus
Public Declare Function GdipDrawArc Lib "gdiplus" (ByVal graphics As Long, ByVal pen As Long, ByVal x As Single, _
        ByVal y As Single, ByVal width As Single, ByVal height As Single, ByVal startAngle As Single, _
        ByVal sweepAngle As Single) As GpStatus
Public Declare Function GdipDrawArcI Lib "gdiplus" (ByVal graphics As Long, ByVal pen As Long, ByVal x As Long, _
        ByVal y As Long, ByVal width As Long, ByVal height As Long, ByVal startAngle As Long, _
        ByVal sweepAngle As Single) As GpStatus
Public Declare Function GdipDrawImage Lib "gdiplus" (ByVal graphics As Long, ByVal Image As Long, ByVal x As Single, _
        ByVal y As Single) As GpStatus
Public Declare Function GdipDrawImageI Lib "gdiplus" (ByVal graphics As Long, ByVal Image As Long, ByVal x As Long, _
        ByVal y As Long) As GpStatus
Public Declare Function GdipDrawLine Lib "gdiplus" (ByVal graphics As Long, ByVal pen As Long, ByVal x1 As Single, _
        ByVal y1 As Single, ByVal x2 As Single, ByVal y2 As Single) As GpStatus
Public Declare Function GdipDrawLineI Lib "gdiplus" (ByVal graphics As Long, ByVal pen As Long, ByVal x1 As Long, _
        ByVal y1 As Long, ByVal x2 As Long, ByVal y2 As Long) As GpStatus
Public Declare Function GdipDrawRectangle Lib "gdiplus" (ByVal graphics As Long, ByVal pen As Long, ByVal x As Single, _
        ByVal y As Single, ByVal width As Single, ByVal height As Single) As GpStatus
Public Declare Function GdipDrawRectangleI Lib "gdiplus" (ByVal graphics As Long, ByVal pen As Long, ByVal x As Long, _
        ByVal y As Long, ByVal width As Long, ByVal height As Long) As GpStatus
Public Declare Function GdipFillRectangle Lib "gdiplus" (ByVal graphics As Long, ByVal brush As Long, ByVal x As Single, _
        ByVal y As Single, ByVal width As Single, ByVal height As Single) As GpStatus
Public Declare Function GdipFillRectangleI Lib "gdiplus" (ByVal graphics As Long, ByVal brush As Long, ByVal x As Long, _
        ByVal y As Long, ByVal width As Long, ByVal height As Long) As GpStatus
Public Declare Function GdipFillEllipse Lib "gdiplus" (ByVal graphics As Long, ByVal brush As Long, ByVal x As Single, _
        ByVal y As Single, ByVal w As Single, ByVal h As Single) As GpStatus
Public Declare Function GdipFillEllipseI Lib "gdiplus" (ByVal graphics As Long, ByVal brush As Long, ByVal x As Long, _
        ByVal y As Long, ByVal w As Long, ByVal h As Long) As GpStatus
Public Declare Function GdipFlush Lib "gdiplus" (ByVal graphics As Long, ByVal intention As FlushIntention) As GpStatus
Public Declare Sub GdipFree Lib "gdiplus" (ByVal ptr As Long)
Public Declare Function GdipGetDC Lib "gdiplus" (ByVal graphics As Long, hdc As Long) As GpStatus
Public Declare Function GdipGetImageGraphicsContext Lib "gdiplus" (ByVal Image As Long, graphics As Long) As GpStatus
Public Declare Function GdipGraphicsClear Lib "gdiplus" (ByVal graphics As Long, ByVal lColor As Long) As GpStatus
Public Declare Function GdipGetImageFlags Lib "gdiplus" (ByVal Image As Long, flags As Long) As GpStatus
Public Declare Function GdipGetImageHeight Lib "gdiplus" (ByVal Image As Long, height As Long) As GpStatus
Public Declare Function GdipGetImageWidth Lib "gdiplus" (ByVal Image As Long, width As Long) As GpStatus
Public Declare Function GdipGetTextureImage Lib "gdiplus" (ByVal brush As Long, Image As Long) As GpStatus
Public Declare Function GdipLoadImageFromFile Lib "gdiplus" (ByVal filename As String, Image As Long) As GpStatus
Public Declare Function GdipLoadImageFromFileICM Lib "gdiplus" (ByVal filename As String, Image As Long) As GpStatus
Public Declare Function GdipMultiplyMatrix Lib "gdiplus" (ByVal matrix As Long, ByVal matrix2 As Long, _
        ByVal order As MatrixOrder) As GpStatus
Public Declare Function GdipReleaseDC Lib "gdiplus" (ByVal graphics As Long, ByVal hdc As Long) As GpStatus
Public Declare Function GdipResetPath Lib "gdiplus" (ByVal Path As Long) As GpStatus
Public Declare Function GdipRestoreGraphics Lib "gdiplus" (ByVal graphics As Long, ByVal state As Long) As GpStatus
Public Declare Function GdipRotateMatrix Lib "gdiplus" (ByVal matrix As Long, ByVal angle As Single, _
        ByVal order As MatrixOrder) As GpStatus
Public Declare Function GdipRotateTextureTransform Lib "gdiplus" (ByVal brush As Long, ByVal angle As Single, _
        ByVal order As MatrixOrder) As GpStatus
Public Declare Function GdipSaveGraphics Lib "gdiplus" (ByVal graphics As Long, state As Long) As GpStatus
Public Declare Function GdipSetRenderingOrigin Lib "gdiplus" (ByVal graphics As Long, ByVal x As Long, _
        ByVal y As Long) As GpStatus

Public Declare Function GdipSetCompositingMode Lib "gdiplus" (ByVal graphics As Long, ByVal compMode As CompositingMode) _
        As GpStatus
Public Declare Function GdipSetCompositingQuality Lib "gdiplus" (ByVal graphics As Long, ByVal compQlty As QualityMode) _
        As GpStatus
Public Declare Function GdipSetPathGradientCenterColor Lib "gdiplus" (ByVal brush As Long, ByVal color As Long) As GpStatus
Public Declare Function GdipSetPathGradientSurroundColorsWithCount Lib "gdiplus" (ByVal brush As Long, argb As Long, _
        cnt As Long) As GpStatus
Public Declare Function GdipSetTextureTransform Lib "gdiplus" (ByVal brush As Long, ByVal matrix As Long) As GpStatus
Public Declare Function GdipSetWorldTransform Lib "gdiplus" (ByVal graphics As Long, ByVal matrix As Long) As GpStatus
Public Declare Function GdipStartPathFigure Lib "gdiplus" (ByVal Path As Long) As GpStatus
Public Declare Function GdipTranslateMatrix Lib "gdiplus" (ByVal matrix As Long, ByVal dx As Single, ByVal dy As Single, _
        ByVal rder As MatrixOrder) As GpStatus
Public Declare Function GdipTranslateTextureTransform Lib "gdiplus" (ByVal brush As Long, ByVal dx As Single, ByVal dy As Single, _
        ByVal order As MatrixOrder) As GpStatus
Public Declare Function GdiplusStartup Lib "gdiplus" (token As Long, inputbuf As GdiplusStartupInput, _
        Optional ByVal outputbuf As Long = 0) As GpStatus
Public Declare Sub GdiplusShutdown Lib "gdiplus" (ByVal token As Long)



' Helper Functions --------------------------------------------------------------------

Public Function ColorARGB(ByVal alpha As Byte, ByVal red As Byte, ByVal green As Byte, ByVal blue As Byte) As Long
    Dim bytestruct As COLORBYTES
    Dim result As COLORLONG
    
    With bytestruct
        .AlphaByte = alpha
        .RedByte = red
        .GreenByte = green
        .BlueByte = blue
    End With
    
    LSet result = bytestruct
    ColorARGB = result.longval
End Function


Public Function status(ByVal s As GpStatus) As String
    Select Case s
        Case 0
                status = "Ok"
        Case 1
                status = "GenericError"
        Case 2
                status = "InvalidParameter"
        Case 3
                status = "OutOfMemory"
        Case 4
                status = "ObjectBusy"
        Case 5
                status = "InsufficientBuffer"
        Case 6
                status = "NotImplemented"
        Case 7
                status = "Win32Error"
        Case 8
                status = "WrongState"
        Case 9
                status = "Aborted"
        Case 10
                status = "FileNotFound"
        Case 11
                status = "ValueOverflow"
        Case 12
                status = "AccessDenied"
        Case 13
                status = "UnknownImageFormat"
        Case 14
                status = "FontFamilyNotFound"
        Case 15
                status = "FontStyleNotFound"
        Case 16
                status = "NotTrueTypeFont"
        Case 17
                status = "UnsupportedGdiplusVersion"
        Case 18
                status = "GdiplusNotInitialized"
        Case 19
                status = "PropertyNotFound"
        Case 20
                status = "PropertyNotSupported"
        Case Else
                status = "Unknown"
    End Select
End Function


'End of file
