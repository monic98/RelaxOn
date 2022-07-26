//
//  StudioView.swift
//  LullabyRecipe
//
//  Created by 김연호 on 2022/07/23.
//

import SwiftUI

struct StudioView: View {
    @State private var select: Int = 0
    @State private var showingAlert = false
    @State private var selectedBaseSound: Sound = Sound(id: 11,
                                                        name: "",
                                                        soundType: .base,
                                                        audioVolume: 0.8,
                                                        imageName: "")
    @State private var selectedMelodySound: Sound = Sound(id: 12,
                                                          name: "",
                                                          soundType: .melody,
                                                          audioVolume: 1.0,
                                                          imageName: "")
    @State private var selectedNaturalSound: Sound = Sound(id: 13,
                                                           name: "",
                                                           soundType: .natural,
                                                           audioVolume: 0.4,
                                                           imageName: "")
    @State var userName: String = ""
    @State private var textEntered = ""
    
    // TODO: Assets 연결 계획
    // TODO: 배열 말고 더 좋은 방법 찾기
    // TODO: 일러스트 바뀔 때 효과
    // TODO: (다음 브랜치에서) 저장 후 홈스크린과 연결
    
    // MARK: 코드 추가
    @State private var selectedImageNames: [String] = ["", "", ""]
    @State var animateVars = [0.0, 0.0, 0.0]

    let baseAudioManager = AudioManager()
    let melodyAudioManager = AudioManager()
    let naturalAudioManager = AudioManager()

    private var items = ["BASE", "MELODY", "NATURAL"]
    var body: some View {
        VStack {
            SelectImage()
            CustomSegmentControlView(items: items, selection: $select)
            switch select {
            case 1:
                SoundSelectView(sectionTitle: "Melody",
                                soundType: .melody)
            case 2:
                SoundSelectView(sectionTitle: "Natural Sound",
                                soundType: .natural)
            default:
                SoundSelectView(sectionTitle: "Base Sound",
                                soundType: .base)
            }
        }
    }

    @ViewBuilder
    func SoundSelectView(sectionTitle: String,
                         soundType: SoundType) -> some View {
        VStack(spacing: 15) {

            HStack {
                Text("볼륨조절 컴포넌트")
            }

            ScrollView(.vertical,
                       showsIndicators: false) {
                HStack(spacing: 30) {
                    switch soundType {
                    case .base:
                        RadioButtonGroup(selectedId: soundType.rawValue,
                                         items: baseSounds) { baseSelected in
                            selectedBaseSound = baseSelected
                            // play music

                            if selectedBaseSound.name == "Empty" {
                                baseAudioManager.stop()
                                
                                animateVars[0] = 0.0
                            } else {
                                baseAudioManager.startPlayer(track: selectedBaseSound.name)
                                
                                selectedImageNames[0] =  selectedBaseSound.imageName
                                animateVars[0] = 0.5
                            }


                        }
                    case .natural:
                        RadioButtonGroup(selectedId: soundType.rawValue,
                                         items: naturalSounds) { naturalSounds in
                            selectedNaturalSound = naturalSounds


                            if selectedNaturalSound.name == "Empty" {
                                naturalAudioManager.stop()
                                
                                animateVars[2] = 0.0
                            } else {
                                naturalAudioManager.startPlayer(track: selectedNaturalSound.name)
                                
                                selectedImageNames[2] = selectedNaturalSound.imageName
                                animateVars[2] = 0.5
                            }
                        }
                    case .melody:
                        RadioButtonGroup(selectedId: soundType.rawValue,
                                         items: melodySounds) { melodySounds in
                            selectedMelodySound = melodySounds
                            
                            if selectedMelodySound.name == "Empty" {
                                melodyAudioManager.stop()
                                
                                animateVars[1] = 0.0
                            } else {
                                melodyAudioManager.startPlayer(track: selectedMelodySound.name)
                                
                                selectedImageNames[1] = selectedMelodySound.imageName
                                animateVars[1] = 0.5
                                
                            }
                        }
                    }
                }
            }.padding(.horizontal, 15)
        }
    }
    
    @ViewBuilder
    func SelectImage() -> some View {
        ZStack {
            Rectangle()
                .frame(width: deviceFrame().exceptPaddingWidth, height: deviceFrame().exceptPaddingWidth, alignment: .center)
                .background(.gray)
            
            ForEach(0...2, id: \.self) { idx in
                Image(selectedImageNames[idx])
                    .resizable()
                    .frame(width: deviceFrame().exceptPaddingWidth, height: deviceFrame().exceptPaddingWidth, alignment: .center)
                    .opacity(animateVars[idx])
                    .animation(.linear, value: animateVars[idx])
            }
        }
    }
}

struct StudioView_Previews: PreviewProvider {
    static var previews: some View {
        StudioView()
    }
}
