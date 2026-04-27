import SwiftUI

struct ContentView: View {
    @State private var slotFrame: CGRect = .zero
    
    var body: some View {
        VStack {
            Text("Adventure time")
                .font(.callout)
                .fontDesign(.monospaced)
                .padding()
            
            // MARK: - Pink Box Empty Slot
            EmptyCardSlot(emptyCardSlotLineColor: .pink)
                .background(
                    GeometryReader { geo in
                        Color.clear
                            .onAppear { slotFrame = geo.frame(in: .global) }
                            .onChange(of: geo.frame(in: .global)) { _, newValue in
                                slotFrame = newValue
                            }
                    }
                )
            
            // MARK: - Card Decks
            HStack {
                DraggableCard(slotFrame: slotFrame)
                DraggableCard(slotFrame: slotFrame)
                DraggableCard(slotFrame: slotFrame)
            }
            .padding()
        }
        .padding()
    }
}

struct DraggableCard: View {
    let slotFrame: CGRect
    
    @State private var offset: CGSize = .zero
    @State private var isLocked: Bool = false
    
    var body: some View {
        CardUIView(cardColor: .yellow)
            .offset(offset)
            .gesture(
                DragGesture(coordinateSpace: .global)
                    .onChanged { value in
                        guard !isLocked else { return }
                        offset = value.translation
                    }
                    .onEnded { value in
                        guard !isLocked else { return }
                        // Check if drop point is inside the pink slot
                        if slotFrame.contains(value.location) {
                            withAnimation(.spring()) {
                                // Snap into the slot
                                offset = CGSize(
                                    width: offset.width + (slotFrame.midX - value.location.x),
                                    height: offset.height + (slotFrame.midY - value.location.y)
                                )
                                isLocked = true
                            }
                        } else {
                            // Snap back
                            withAnimation(.spring()) {
                                offset = .zero
                            }
                        }
                    }
            )
    }
}
