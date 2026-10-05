import SwiftUI

struct CheckboxButton: View {
    let isChecked: Bool
    let color: Color
    let action: () -> Void
    
    @State private var isAnimating = false
    
    var body: some View {
        Button(action: {
            withAnimation(.spring(response: 0.3, dampingFraction: 0.6)) {
                isAnimating = true
            }
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.15) {
                action()
                isAnimating = false
            }
        }) {
            ZStack {
                Circle()
                    .strokeBorder(isChecked ? color : Color(.tertiaryLabel), lineWidth: 2)
                    .fill(isChecked ? color.opacity(0.1) : Color.clear)
                    .frame(width: 28, height: 28)
                if isChecked {
                    Image(systemName: "checkmark")
                        .font(.system(size: 12, weight: .bold))
                        .foregroundStyle(color)
                }
            }
        }
        .scaleEffect(isAnimating ? 1.2 : 1.0)
        .buttonStyle(.plain)
        .accessibilityLabel(isChecked ? "Mark as incomplete" : "Mark as complete")
    }
}
