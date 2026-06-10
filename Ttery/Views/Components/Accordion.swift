//
//  Accordion.swift
//  Team17Project
//
//  Created by Imelda Damayanti on 03/06/26.

import SwiftUI

struct AccordionItem: View {
    let title: String
    let paragraphs: [Text]
    
    @State private var isExpanded = false
    
    var body: some View {
        ZStack(alignment: .top) {
            if isExpanded {
                VStack(alignment: .leading, spacing: 16) {
                    ForEach(Array(paragraphs.enumerated()), id: \.offset) { _, paragraph in
                        paragraph
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
                        Text("ttery is an **energy companion**. there’s no locks, timers, or day schedules - just an **energy bar** that lets you determine what tasks to prioritize at any given moment."),
                        
                        Text("head over to the **marketplace**. this is your menu of tasks, classified as either energizing (adds to your energy) or draining (takes from it), in varying amounts. you can long press a task to edit the existing settings at any time, or create custom ones."),
                        
                        Text("add up to 4 tasks to your cart, using the mini energy bar at the top right corner as a preview of how your energy will change as you complete these tasks."),
                        
                        Text("once you return to the home screen, our app **mascot** ttery will accompany you while you work on any of your chosen tasks at a time. when you’ve completed it, your actual energy bar will update. no pressure, though - if you change your mind, you can cancel the task with no holds barred."),
                        
                        Text("when you clear up a slot of your cart, you can add another. the app never resets your energy level - it’ll always be accurate to how you feel, as long as you keep updating it. you’ll also get **hourly check-ins** from ttery in case you lose track of time!"),
                        
                        Text("ttery wants to **build habits** of accountability with you, and help you **make healthier** choices of what to do with your time - whatever that looks like to YOU.")
                        
                    ]
                )
                
                AccordionItem(
                    title: "the story behind ttery",
                    paragraphs: [
                        
                        Text("we at clockout studios set out on a mission to **empower ADHD youth**, and all others who relate, to **reclaim their time** in an era of dopamine numbness and an overarching attention economy."),
                        
                        Text("to get started, we **interviewed individuals diagnosed with ADHD** in a wide range of fields and places in life, medicated and otherwise, to get a good picture of what works, what doesn’t work, and everything in between."),
                        
                        Text("this was followed up with **deep research** on the psychology of each pain point, and the real-life situations that worsen them."),
                        
                        Text("the core functionality of the app is inspired by three things that work for our user persona:"),
                        
                        Text("""
                        • dopamine menu: a **divided set of activity options**
                        to be referenced whenever they’re unsure what to
                        do, or what needs to be done
                        """),
                        
                        Text("""
                        • spoon theory: a classic system to organize one’s
                        **limited energy reserves**, re-scaled to fit more
                        continuous usage, instead of on a daily basis
                        """),
                        
                        Text("""
                        • body doubling: loosely, ttery’s presence as a virtual
                        friend who checks in and hangs around can help
                        **provide a sense of company** in each task
                        """),
                        
                        Text("we realize there can never be a one-size-fits-all solution to matters of the mind, and we don’t hope to arrive at one. we just hope ttery reaches and helps those that need something like it :)")
                        
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


