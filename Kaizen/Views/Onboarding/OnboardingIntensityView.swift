import SwiftUI

struct OnboardingIntensityView: View {
    @Binding var selectedIntensity: DayIntensity
    let onNext: () -> Void
    let onBack: () -> Void
    
    var body: some View {
        VStack(spacing: 0) {
            VStack(spacing: 8) {
                Text("How many habits can you realistically handle?")
                    .font(.title2)
                    .fontWeight(.bold)
                    .multilineTextAlignment(.center)
                Text("Consistency over quantity. Start small.")
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
            }
            .padding(.top, 60)
            .padding(.horizontal, 32)
            
            Spacer()
            
            VStack(spacing: 12) {
                ForEach(DayIntensity.allCases, id: \.rawValue) { intensity in
                    IntensityButton(
                        intensity: intensity,
                        isSelected: selectedIntensity == intensity
                    ) {
                        selectedIntensity = intensity
                    }
                }
            }
            .padding(.horizontal, 24)
            
            Spacer()
            
            HStack(spacing: 12) {
                Button("Back", action: onBack)
                    .buttonStyle(.bordered)
                    .tint(.secondary)
                    .frame(maxWidth: .infinity)
                Button("Continue", action: onNext)
                    .buttonStyle(.borderedProminent)
                    .tint(.kaizenAccent)
                    .frame(maxWidth: .infinity)
            }
            .controlSize(.large)
            .padding(.horizontal, 24)
            .padding(.bottom, 48)
        }
    }
}

// MARK: - IntensityButton

struct IntensityButton: View {
    let intensity: DayIntensity
    let isSelected: Bool
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            HStack(spacing: 16) {
                Image(systemName: intensity.icon)
                    .font(.title3)
                    .foregroundStyle(isSelected ? .white : .kaizenAccent)
                    .frame(width: 32)
                VStack(alignment: .leading, spacing: 2) {
                    Text(intensity.displayName)
                        .font(.headline)
                        .foregroundStyle(isSelected ? .white : .primary)
                    Text(intensity.subtitle)
                        .font(.subheadline)
                        .foregroundStyle(isSelected ? .white.opacity(0.8) : .secondary)
                }
                Spacer()
                if isSelected {
                    Image(systemName: "checkmark.circle.fill")
                        .foregroundStyle(.white)
                }
            }
            .padding(16)
            .background(isSelected ? Color.kaizenAccent : Color(.secondarySystemBackground))
            .clipShape(RoundedRectangle(cornerRadius: 14, style: .continuous))
        }
        .buttonStyle(.plain)
        .animation(.spring(response: 0.3, dampingFraction: 0.7), value: isSelected)
    }
}
