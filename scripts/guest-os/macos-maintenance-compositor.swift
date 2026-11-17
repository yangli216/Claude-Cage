import CoreGraphics

// macOS 15 gives these Apple compositor surfaces full-display bounds even
// when their contents occupy only the Dock or notification banner area.
// The caller still verifies the foreground Settings/authorization app before
// and after every frame and input operation, including secure password focus.
func macMaintenanceCompositorSurface(bundle: String, appleSigned: Bool, layer: Int,
                                     bounds: CGRect, display: CGRect, systemMajor: Int) -> Bool {
    guard systemMajor == 15, appleSigned, !display.isEmpty,
          bounds == display else { return false }
    return bundle == "com.apple.dock" && layer == 20 ||
        bundle == "com.apple.notificationcenterui" && layer == 23
}

// WindowServer exposes the hardware cursor as a tiny top-layer window. It is
// not an application obscuring Settings. Keep all other windows fail-closed.
func macMaintenanceCursorSurface(appleSigned: Bool, layer: Int, bounds: CGRect, cursor: CGPoint?) -> Bool {
    guard appleSigned, layer == 2147483630, let cursor,
          bounds.width > 0, bounds.height > 0, bounds.width <= 64, bounds.height <= 64 else { return false }
    return bounds.contains(cursor)
}
