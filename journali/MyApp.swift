import SwiftUI

@main
struct MyApp: App {

    // هل خلص الـ Splash؟
    @State private var showSplash = true

    var body: some Scene {
        WindowGroup {
            ZStack {
                if showSplash {
                    SplashView()
                        .transition(.opacity)
                } else {
                    MainPage()
                        .preferredColorScheme(.dark)
                        .transition(.opacity)
                }
            }
            .onAppear {
                // ننتظر ثانيتين ثم ننتقل للصفحة الرئيسية
                DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                    withAnimation(.easeInOut(duration: 0.5)) {
                        showSplash = false
                    }
                }
            }
        }
    }
}
