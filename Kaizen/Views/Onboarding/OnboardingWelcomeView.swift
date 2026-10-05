import SwiftUI

struct OnboardingWelcomeView: View {
    @Binding var userName: String
    let onNext: () -> Void
    
    var body: some View {
        VStack(spacing: 0) {
            Spacer()
            
            VStack(spacing: 24) {
                VStack(spacing: 12) {
                    Text("改善")
                        .font(.system(size: 60, weight: .ultraLight))
                        .foregroundStyle(.kaizenAccent)
                    Text("Kaizen")
                        .font(.largeTitle)
                        .fontWeight(.bold)
                    Text("Build your life\none day at a time.")
                        .font(.title3)
                        .foregroundStyle(.secondary)
                        .multilineTextAlignment(.center)
                }
                
                VStack(spacing: 8) {
                    Text("What should we call you?")
                        .font(.subheadline)
                        .foregroundStyle(.secondary)
                    TextField("Your name", text: $userName)
                        .font(.body)
                        .padding()
                        .background(Color(.secondarySystemBackground))
                        .clipShape(RoundedRectangle(cornerRadius: 12, style: .continuous))
                        .autocorrectionDisabled()
                }
                .padding(.top, 16)
            }
            .padding(.horizontal, 32)
            
            Spacer()
            
            VStack(spacing: 12) {
                Button(action: onNext) {
                    Text("Get Started")
                        .font(.headline)
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.kaizenAccent)
                        .foregroundStyle(.white)
                        .clipShape(RoundedRectangle(cornerRadius: 14, style: .continuous))
                }
                .padding(.horizontal, 32)
                
                Text("No account required. Your data stays on your device.")
                    .font(.caption)
                    .foregroundStyle(.secondary)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal, 32)
            }
            .padding(.bottom, 48)
        }
    }
}
