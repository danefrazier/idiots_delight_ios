import SwiftUI

struct AboutView: View {
    @Environment(\.dismiss) private var dismiss

    var body: some View {
        NavigationStack {
            ZStack {
                Color(red: 0.1, green: 0.35, blue: 0.14)
                    .ignoresSafeArea()

                VStack(spacing: 32) {
                    Spacer()

                    Image(systemName: "suit.spade.fill")
                        .font(.system(size: 60))
                        .foregroundColor(.white.opacity(0.85))

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
