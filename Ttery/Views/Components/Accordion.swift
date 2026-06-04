//
//  Accordion.swift
//  Team17Project
//
//  Created by Imelda Damayanti on 03/06/26.

import SwiftUI

struct AccordionItem: View {
    let title: String
    let paragraphs: [String]

    @State private var isExpanded = false

    var body: some View {
        ZStack(alignment: .top) {
            if isExpanded {
                VStack(alignment: .leading, spacing: 16) {
                    ForEach(paragraphs, id: \.self) { text in
                        Text(text)
                            .font(.system(size: 13))
                            .foregroundColor(.black.opacity(0.8))
                    }
                }
                .padding(.horizontal, 20)
                .padding(.top, 50)
                .padding(.bottom, 20)
                .background(Color.white)
                .clipShape(RoundedRectangle(cornerRadius: 20))
                .overlay(
                    RoundedRectangle(cornerRadius: 20)
                        .stroke(Color.black, lineWidth: 1)
                )
                .background(
                    RoundedRectangle(cornerRadius: 20)
                        .fill(Color.black)
                        .offset(y: 6)
                )
            }

            Button {
                withAnimation(.easeInOut(duration: 0.25)) {
                    isExpanded.toggle()
                }
            } label: {
                HStack {
                    Spacer()

                    Text(title)
                        .font(.system(size: 13, weight: .semibold))
                        .foregroundColor(.black)

                    Spacer()

                    Image(systemName: "chevron.down")
                        .rotationEffect(.degrees(isExpanded ? 180 : 0))
                        .foregroundColor(.black)
                }
                .padding(.horizontal, 20)
                .frame(height: 40)
            }
            .background(Color.white)
            .clipShape(Capsule())
            .overlay(
                Capsule()
                    .stroke(Color.black, lineWidth: 1)
            )
         
            .background(
                !isExpanded
                  ? AnyView(
                      Capsule()
                          .fill(Color.black)
                          .offset(y: 6)
                    )
                  : AnyView(EmptyView())

            )
            .zIndex(1)
        }

    }
}


struct AccordionListView: View {
    var body: some View {
        ScrollView {
            VStack(spacing: 24) {
                AccordionItem(
                    title: "how the app works",
                    paragraphs: [
                        "ttery is an energy organizer. there’s no locks, timers, or day schedules - ju  st an energy bar that lets you determine what tasks to prioritize at any given moment.",
                        "simply head on over to the marketplace. this is your menu of tasks, classified as either energizing (adds to your energy) or draining (takes from it). you can edit the existing tasks, or create custom ones.",
                        "add up to 4 tasks to your cart, using the energy bar here as a preview.",
                        "once you return to the home screen, our app mascot ttery will help you focus while you work on one task at a time. when you’ve completed it, your energy bar will update. no pressure, though - you can cancel the task with no holds barred.",
                        "ttery wants you to build habits of accountability and healthier choices of what to do with your time, whatever that looks like to YOU."
                    ]
                )
                
                AccordionItem(
                    title: "the story behind ttery",
                    paragraphs: [
                        "we, the devs, set out on a mission to empower ADHD youth to reclaim their time in an era of dopamine numbness, decision fatigue, and lowering attention spans.",
                        "the irony of trying to solve problems largely worsened by technological overuse, with an app on your phone, is not lost on us! but fight fire with fire, or whatever.",
                        "we interviewed individuals diagnosed with ADHD in a wide range of fields and places in life, medicated and otherwise, to get a good picture of what works, what doesn’t work, and everything in between.",
                        "the core functionality of the app is inspired by three things that work for our user persona - body doubling, a dopamine menu, and spoon theory. they’re all a little modified to fit the purpose, but they’re in there.",
                        "we realize there can never be a one-size-fits-all solution to matters of the mind, and we don’t hope to arrive at one. we just hope ttery reaches and helps those that need something like it."
                    ]                )
            }
            .padding(.horizontal, 16)
            .padding(.top, 20)
        }
        
    }
}
#Preview {
    AccordionListView()
}


