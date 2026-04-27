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
    @State private var cardCenterAtDragStart: CGPoint = .zero
    @State private var fingerOffsetFromCenter: CGSize = .zero
    @State private var hasRecordedStart: Bool = false
    
    var body: some View {
        CardUIView(cardColor: .yellow)
            .background(
                GeometryReader { geo -> Color in
                    // Continuously track card's center in global space (only matters before drag)
                    let frame = geo.frame(in: .global)
                    DispatchQueue.main.async {
                        if !hasRecordedStart && offset == .zero {
                            cardCenterAtDragStart = CGPoint(x: frame.midX, y: frame.midY)
                        }
                    }
                    return Color.clear
                }
            )
            .offset(offset)
            .gesture(
                DragGesture(coordinateSpace: .global)
                    .onChanged { value in
                        guard !isLocked else { return }
                        
                        // On the first frame of the drag, record where the finger
                        // is relative to the card's center.
                        if !hasRecordedStart {
                            fingerOffsetFromCenter = CGSize(
                                width: value.startLocation.x - cardCenterAtDragStart.x,
                                height: value.startLocation.y - cardCenterAtDragStart.y
                            )
                            hasRecordedStart = true
                        }
                        
                        offset = value.translation
                    }
                    .onEnded { value in
                        guard !isLocked else { return }
                        
                        // Where the card's center actually is right now
                        let cardCenterNow = CGPoint(
                            x: value.location.x - fingerOffsetFromCenter.width,
                            y: value.location.y - fingerOffsetFromCenter.height
                        )
                        
                        if slotFrame.contains(cardCenterNow) {
                            withAnimation(.spring()) {
                                // Snap so the card's center lands on the slot's center
                                offset = CGSize(
                                    width: offset.width + (slotFrame.midX - cardCenterNow.x),
                                    height: offset.height + (slotFrame.midY - cardCenterNow.y)
                                )
                                isLocked = true
                            }
                        } else {
                            withAnimation(.spring()) {
                                offset = .zero
                            }
                        }
                        
                        hasRecordedStart = false
                        /*
                         NOTE:
                         1. [V] set the drop more correct
                         2. [ ] game topic for drop items, like how to sort the house?
                         3. [ ] how to make score 
                         4. [ ] bacground color
                         */
                    }
            )
    }
}
