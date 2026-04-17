import SwiftUI

struct AboutView: View {
    @Environment(\.dismiss) private var dismiss

    private var versionString: String {
        let version = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String ?? "1.0"
        let build = Bundle.main.infoDictionary?["CFBundleVersion"] as? String ?? "1"
        return "v\(version) (\(build))"
    }

    var body: some View {
        NavigationStack {
            ZStack {
                Color(red: 0.1, green: 0.35, blue: 0.14)
                    .ignoresSafeArea()

                VStack(spacing: 32) {
                    Spacer()

                    Image("Joker")
                        .resizable()
                        .scaledToFit()
                        .frame(maxWidth: 260)
                        .padding(.horizontal, 24)

                    VStack(spacing: 16) {
                        Text("Idiot's Delight")
                            .font(.title.bold())
                            .foregroundColor(.white)

                        Text("Developed by D. Frazier")
                            .font(.headline)
                            .foregroundColor(.white.opacity(0.8))
                    }

                    Text("This game was taught by family friends while at a cabin in the mountains on a weekend trip in the 1980s.\n\nThis is an homage to good times, and good friends.")
                        .font(.body)
                        .foregroundColor(.white.opacity(0.75))
                        .multilineTextAlignment(.center)
                        .lineSpacing(4)
                        .padding(.horizontal, 36)

                    Spacer()

                    Text(versionString)
                        .font(.caption2)
                        .foregroundColor(.white.opacity(0.35))
                        .padding(.bottom, 16)
                }
            }
            .navigationTitle("About")
            .navigationBarTitleDisplayMode(.inline)
            .toolbarBackground(Color(red: 0.1, green: 0.35, blue: 0.14), for: .navigationBar)
            .toolbarColorScheme(.dark, for: .navigationBar)
            .toolbar {
                ToolbarItem(placement: .confirmationAction) {
                    Button("Done") { dismiss() }
                }
            }
        }
    }
}

#Preview {
    AboutView()
}
