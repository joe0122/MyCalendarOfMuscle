//
//  SearchModel.swift
//  MyCalendarOfMuscle
//
//  Created by 矢嶋丈 on 2020/11/19.
//

import Foundation
import UIKit

class SearchModel{
    
    func searchPosition(menuData:MenuData) -> UIImage?{
        
        let positionArray = menuData.position
        
        switch positionArray.count {
        case 0:
            return nil
        case 1:
            if positionArray.contains("腕"){
                return udeImg
            }else if positionArray.contains("肩"){
                return kataImg
            }else if positionArray.contains("胸"){
                return muneImg
            }else if positionArray.contains("腹"){
                return haraImg
            }else if positionArray.contains("背"){
                return senakaImg
            }else if positionArray.contains("脚"){
                return ashiImg
            }else if positionArray.contains("有"){
                return yuuImg
            }
        case 2:
            if positionArray.contains("腕"){
                if positionArray.contains("肩"){
                    return udekata
                }else if positionArray.contains("胸"){
                    return udemune
                }else if positionArray.contains("腹"){
                    return udehara
                }else if positionArray.contains("背"){
                    return udesenaka
                }else if positionArray.contains("脚"){
                    return udeashi
                }else if positionArray.contains("有"){
                    return udeyuu
                }
            }else if positionArray.contains("肩"){
                if positionArray.contains("胸"){
                    return katamune
                }else if positionArray.contains("腹"){
                    return katahara
                }else if positionArray.contains("背"){
                    return katasenaka
                }else if positionArray.contains("脚"){
                    return kataashi
                }else if positionArray.contains("有"){
                    return katayuu
                }
            }else if positionArray.contains("胸"){
                if positionArray.contains("腹"){
                    return munehara
                }else if positionArray.contains("背"){
                    return munesenaka
                }else if positionArray.contains("脚"){
                    return muneashi
                }else if positionArray.contains("有"){
                    return muneyuu
                }
            }else if positionArray.contains("腹"){
                if positionArray.contains("背"){
                    return harasenaka
                }else if positionArray.contains("脚"){
                    return haraashi
                }else if positionArray.contains("有"){
                    return harayuu
                }
            }else if positionArray.contains("背"){
                if positionArray.contains("脚"){
                    return senakaashi
                }else if positionArray.contains("有"){
                    return senakayuu
                }
            }else{
                    return ashiyuu
                }
        case 3:
            if positionArray.contains("腕") && positionArray.contains("肩"){
                if positionArray.contains("胸"){
                    return udekatamune
                }else if positionArray.contains("腹"){
                    return udekatahara
                }else if positionArray.contains("背"){
                    return udekatasenaka
                }else if positionArray.contains("脚"){
                    return udekataashi
                }else if positionArray.contains("有"){
                    return udekatayuu
                }
            }else if positionArray.contains("腕") && positionArray.contains("胸"){
                if positionArray.contains("腹"){
                    return udemunehara
                }else if positionArray.contains("背"){
                    return udemunesenaka
                }else if positionArray.contains("脚"){
                    return udemuneashi
                }else if positionArray.contains("有"){
                    return udemuneyuu
                }
            }else if positionArray.contains("腕") && positionArray.contains("腹"){
                if positionArray.contains("背"){
                    return udeharasenaka
                }else if positionArray.contains("脚"){
                    return udeharaashi
                }else if positionArray.contains("有"){
                    return udeharayuu
                }
            }else if positionArray.contains("腕") && positionArray.contains("背"){
                if positionArray.contains("脚"){
                    return udesenakaashi
                }else if positionArray.contains("有"){
                    return udesenakayuu
                }
            }else if positionArray.contains("腕") && positionArray.contains("脚"){
                return udeashiyuu
            }else if positionArray.contains("肩") && positionArray.contains("胸"){
                if positionArray.contains("腹"){
                    return katamunehara
                }else if positionArray.contains("背"){
                    return katamunesenaka
                }else if positionArray.contains("脚"){
                    return katamuneashi
                }else if positionArray.contains("有"){
                    return katamuneyuu
                }
            }else if positionArray.contains("肩") && positionArray.contains("腹"){
                if positionArray.contains("背"){
                    return kataharasenaka
                }else if positionArray.contains("脚"){
                    return kataharaashi
                }else if positionArray.contains("有"){
                    return kataharayuu
                }
            }else if positionArray.contains("肩") && positionArray.contains("背"){
                if positionArray.contains("脚"){
                    return katasenakaashi
                }else if positionArray.contains("有"){
                    return katasenakayuu
                }
            }else if positionArray.contains("肩") && positionArray.contains("脚"){
                return kataashiyuu
            }else if positionArray.contains("胸") && positionArray.contains("腹"){
                if positionArray.contains("背"){
                    return muneharasenaka
                }else if positionArray.contains("脚"){
                    return muneharaashi
                }else if positionArray.contains("有"){
                    return muneharayuu
                }
            }else if positionArray.contains("胸") && positionArray.contains("背"){
                if positionArray.contains("脚"){
                    return munesenakaashi
                }else{
                    return munesenakayuu
                }
            }else if positionArray.contains("胸") && positionArray.contains("脚"){
                return muneashiyuu
            }else if positionArray.contains("腹") && positionArray.contains("背"){
                if positionArray.contains("脚"){
                    return harasenakaashi
                }else{
                    return harasenakayuu
                }
            }else if positionArray.contains("腹") && positionArray.contains("脚"){
                return haraashiyuu
            }else{
                return senakaashiyuu
            }
            
        default:
            break
        }
        
        return nil
    }
}

