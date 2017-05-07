//
//  WhyFBLAViewController.swift
//  FBLA2017
//
//  Created by Luke Mann on 5/7/17.
//  Copyright © 2017 Luke Mann. All rights reserved.
//
import UIKit
import paper_onboarding

class WhyFBLAViewController
: UIViewController {
    
    @IBOutlet weak var onboarding: PaperOnboarding!
    
    let image = UIImage(named: "CloseButton") as UIImage?
    let button = UIButton(type: UIButtonType.custom) as UIButton
    
    
 
    
    
}

extension WhyFBLAViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor=UIColor.black
    }
    
    
    override var shouldAutorotate: Bool {
        return false
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
    }
}

extension WhyFBLAViewController: PaperOnboardingDelegate {
    
    func onboardingWillTransitonToIndex(_ index: Int) {
    }
    
    func onboardingDidTransitonToIndex(_ index: Int) {
        
    }
    
    func onboardingConfigurationItem(_ item: OnboardingContentViewItem, index: Int) {
        
    }
}

extension WhyFBLAViewController: PaperOnboardingDataSource {
    
    func onboardingItemAtIndex(_ index: Int) -> OnboardingItemInfo {
        let titleFont = UIFont(name: "Nunito-Bold", size: 36.0) ?? UIFont.boldSystemFont(ofSize: 36.0)
        let descriptionFont = UIFont(name: "OpenSans-Regular", size: 14.0) ?? UIFont.systemFont(ofSize: 14.0)
        return [
            ("NetworkSkills", "Networking Skills", "Every student who joins FBLA and attends a conference or workshop always walks away with new networking skills. Over 10,000 students attend the NLC; everyone is bound to make one new friend.", "NetworkSkillsSmall", UIColor(red:0/255, green:58/255, blue:132/255, alpha:1.00), UIColor.white, UIColor.white, titleFont,descriptionFont),
            ("PublicSpeaking", "Public Speaking", "FBLA allows students to grow out of their shell. Students meet other students everywhere, in the elevator, conference room and even at dinner. By the end of the conference, no one is shy and everyone now has new communication skills.", "PublicSpeakingSmall", UIColor(red:233/255, green:102/255, blue:86/255, alpha:1.00), UIColor.white, UIColor.white, titleFont,descriptionFont),
            ("Teamwork", "Teamwork", "There are over 60 events for every student to compete in. Those which are group events allow students to learn about every dynamic when working in a group. Students learn how to solve and prevent problems that may arise.", "TeamworkSmall", UIColor(red:52/255, green:210/255, blue:147/255, alpha:1.00), UIColor.white, UIColor.white, titleFont,descriptionFont),
            ("Leadership", "Leadership", "When students join FBLA they join an organization that will make them the leaders of tomorrow. Leaders will be the ones that will be more successful and wealthy in the future.", "LeadershipSmall", UIColor(red:247/255, green:216/255, blue:97/255, alpha:1.00), UIColor.white, UIColor.white, titleFont,descriptionFont)
            ][index]
    }
    
    func onboardingItemsCount() -> Int {
        return 4
    }
}




