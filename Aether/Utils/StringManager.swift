//
//  StringManager.swift
//  Aether
//
//  Created by Bruno Pastre on 20/11/20.
//  Copyright © 2020 Bruno Pastre. All rights reserved.
//

import Foundation

enum AEStrings {
    enum NewAccessoryViewController {
        enum Button {
            static let connect: String = NSLocalizedString("Conectar", comment: "")
        }
        enum Label {
            static let searching: String = NSLocalizedString("Procurando", comment: "")
            static let found: String = NSLocalizedString("Encontrado", comment: "")
            static let newAccessory: String = NSLocalizedString("Novo acessorio", comment: "")
            
        }
    }
    enum AddRoomViewController {
        enum Carousel {
            static let title: String = NSLocalizedString("Ícone do cômodo", comment: "")
        }
        enum Label {
            static let newRoom: String = NSLocalizedString("Criar cômodo", comment: "")
            static let editRoom: String = NSLocalizedString("Editar cômodo", comment: "")
        }
        enum TextField {
            static let roomName: String = NSLocalizedString("   Nome do cômodo", comment: "")
        }
        enum Button {
            static let save: String = NSLocalizedString("Pronto", comment: "")
        }
    }
    enum HomeViewController {
        enum Label {
            static let title: String = NSLocalizedString("Bem-vindo", comment: "")
            static let subtitle: String = NSLocalizedString("Cômodos", comment: "")
            static let noDevices: String = NSLocalizedString("Sem dispositivo", comment: "")
        }
    }
    enum Alert {
        enum Unavailable {
            static let title: String = "Ops!"
            static let message: String = NSLocalizedString("Indisponivel", comment: "")
            enum Action {
                static let ok: String = "Ok"
            }
        }
        enum SearchError {
            static let title: String = NSLocalizedString("Não encontri nenhum lugar", comment: "")
            enum Action {
                static let ok: String = "OK"
            }
        }
        enum Delete {
            static let title: String = NSLocalizedString("Delete Titulo", comment: "")
            static let message: String = NSLocalizedString("Delete description", comment: "")
        }
        enum Permission {
            static let title: String = NSLocalizedString("Aether gostaria de usar", comment: "")
            static let message: String = NSLocalizedString("Permitir nos ajustes", comment: "")
            enum Action {
                static let title: String = NSLocalizedString("Ajustes", comment: "")
                static let no: String = NSLocalizedString("Agora não", comment: "")
            }
        }
        enum Action {
            static let yes: String = NSLocalizedString("Sim", comment: "")
            static let no: String = NSLocalizedString("Não", comment: "")
        }
        enum Scene {
            static let alertTitle: String = NSLocalizedString("Alert Title", comment: "")
            static let confirmation: String = NSLocalizedString("Ok", comment: "")
        }
    }
    enum EditAccessoryViewController {
        enum Button {
            static let save: String = NSLocalizedString("Salvar", comment: "")
            static let delete: String = NSLocalizedString("Apagar", comment: "")
        }
        
        enum Label {
            static let room: String = NSLocalizedString("Cômodo", comment: "")
            static let favorite: String = NSLocalizedString("Favorito", comment: "")
        }
    }
    enum AddActionMenu {
        enum Label {
            static let newLamp: String = NSLocalizedString("     Novo acessório", comment: "")
            static let newRoom: String = NSLocalizedString("     Novo cômodo", comment: "")
        }
    }
    enum IntroductionOnboardingViewController {
        enum Label {
            enum Description {
                static let start: String = NSLocalizedString("Intro descricao", comment: "")
                static let aether: String = NSLocalizedString("Aether", comment: "")
                static let other: String = NSLocalizedString("Outro", comment: "")
                
            }
            static let start: String = NSLocalizedString("Vamos lá", comment: "")
        }
    }
    enum LampSetupViewController {
        enum Button {
            static let next: String = NSLocalizedString("Próximo", comment: "")
            static let ready: String = NSLocalizedString("Pronto", comment: "")
        }
        enum Instructions {
            enum First {
                static let title: String = NSLocalizedString("Primeiro passo", comment: "")
                static let description: String = NSLocalizedString("Primeira descricao", comment: "Desligue o interruptor da lâmpada escolhida! Ele está desligado?")
            }
            enum Second {
                static let title: String = NSLocalizedString("Segundo passo", comment: "")
                static let description: String = NSLocalizedString("Segunda descricao", comment: "Desligue o interruptor da lâmpada escolhida! Ele está desligado?")
            }
            enum Third {
                static let title: String =  NSLocalizedString("Terceiro passo", comment: "")
                static let description: String =  NSLocalizedString("Terceira descricao", comment: "")
            }
        }
    }
    enum WelcomeViewController {
        enum Label {
            static let title: String = NSLocalizedString("Bem-vindo", comment: "")
            static let description: String = NSLocalizedString("Bem-vindo description", comment: "")
        }
        enum Button {
            static let start: String = NSLocalizedString("Começar", comment: "")
            static let haventReceived: String = NSLocalizedString("Não recebi", comment: "")
        }
    }
    enum WifiConfigurationViewController {
        enum Label {
            static let registerTitle: String = NSLocalizedString("Cadastre Wifi", comment: "")
            static let description: String = NSLocalizedString("Wifi description", comment: "")
            static let invalidWifi: String = NSLocalizedString("Wifi invalido", comment: "")
            
        }
        
        enum TextField {
            static let wifi: String = NSLocalizedString("Nome Wifi placeholder", comment: "")
            static let password: String =  NSLocalizedString("Senha Wifi placeholder", comment: "")
        }
        
        enum Button {
            static let `continue`: String = NSLocalizedString("Continuar", comment: "")
        }
    }
    enum AEPermissionsViewController {
        enum Label {
            static let title: String = NSLocalizedString("Vamos lá", comment: "")
            static let description: String =  NSLocalizedString("desc", comment: "")
        }
    }
    enum SceneBuilder {
        static let defaultSceneName: String = NSLocalizedString("Cena Aether", comment: "")
    }
    enum ScenesView {
        enum Navigation {
            static let title: String = NSLocalizedString("Cenas", comment: "")
            static let description: String = NSLocalizedString("Cenas", comment: "")
        }
    }
    enum CreateSceneViewController {
        enum Label {
            static let title: String = NSLocalizedString("Criar cena", comment: "")
            static let description: String = NSLocalizedString("Escolha quando quer que a automação ocorra", comment: "")
        }
    }
    enum AutomationStartCondition {
        enum Title {
            static let peopleArrive: String =  NSLocalizedString("Pessoas chegarem", comment: "")
            static let peopleLeave: String =  NSLocalizedString("Pessoas saírem", comment: "")
            static let time: String =  NSLocalizedString("Um horário", comment: "")
            static let otherAccessory: String =  NSLocalizedString("Um acessório é controlado", comment: "")
        }
        enum Description {
            
            static let peopleArrive: String = NSLocalizedString("\"Ao chegar em casa\"", comment: "")
            static let peopleLeave: String = NSLocalizedString("\"Todos já saíram\"", comment: "")
            static let time: String = NSLocalizedString("\"Às 8h\"", comment: "")
            static let otherAccessory: String = NSLocalizedString("Ex. \"Acender as luzes\"", comment: "")
        }
    }
    enum AutomationStartViewController {
        enum Label {
            static let title: String = NSLocalizedString("Criar cena", comment: "")
            static let description: String = NSLocalizedString("Escolha quando quer que a automação ocorra", comment: "")
        }
    }
    enum LocationSuggestionTableViewController {
        enum TableView {
            static let header: String = NSLocalizedString("SEARCH_RESULTS", comment: "Standard result text")
            static let template: String =  NSLocalizedString("SEARCH_RESULTS_LOCATION", comment: "Search result text with city")
        }
    }
    enum MetadataPickerView {
        enum TextField {
            static let placeholder: String = NSLocalizedString("   Nome da cena", comment: "")
        }
        enum Carousel {
            static let title: String = NSLocalizedString(
                "Ícone da cena",
                comment: ""
            )
        }
    }
    enum TimePicker {
        enum Label {
            static let time: String = NSLocalizedString("Time", comment: "")
            
        }
    }
    enum SceneUserInput {
        static let any: String = NSLocalizedString("Qualquer", comment: "")
        static let location: String = NSLocalizedString("Localização", comment: "")
        static let time: String = NSLocalizedString("Horário", comment: "")
        static let days: String = NSLocalizedString("Dias", comment: "")
    }
    enum SceneAutomationViewController {
        enum Button {
            static let next: String = NSLocalizedString("Próximo", comment: "")
            static let ready: String = NSLocalizedString("Pronto", comment: "")
        }
        
        enum SceneAutomationFlowConfigurator {
            static let triggerTitle: String = NSLocalizedString(
                "Escolha quando quer que a automação ocorra",
                comment: ""
            )
            static let lampPickerTitle: String = NSLocalizedString(
                "Escolha as lâmpadas que deseja automatizar",
                comment: ""
            )
            static let metadataPickerTitle: String = NSLocalizedString(
                "Nome da cena",
                comment: ""
            )
            
        }
    }
    enum SceneAutomationFlowConfigurator {
        enum Label {
            static let accessories: String = NSLocalizedString("Acessórios", comment: "")
            
        }
        enum SwitchOptionView {
            static let time: String = NSLocalizedString("Horário", comment: "")
            static let days: String = NSLocalizedString("Dias", comment: "")
            static let location: String = NSLocalizedString("Localização", comment: "")
        }
    }
    enum SettingsViewController {
        enum Navigation {
            static let title: String = NSLocalizedString("Ajustes", comment: "")
        }
        
        enum AEAjustesOptionView {
            static let share: String = NSLocalizedString("Compartilhar casa", comment: "")
            static let changeWifi: String = NSLocalizedString("Alterar WiFi", comment: "")
            static let changeHome: String = NSLocalizedString("Alterar casa", comment: "")
            static let update: String = NSLocalizedString("Atualização", comment: "")
        }
        
        enum Label {
            static let house: String = NSLocalizedString("Casa", comment: "")
        }
    }
    
    enum LojaViewController {
        enum Label {
            static let description: String = NSLocalizedString("Descricao loja", comment: "")
            static let productName: String = "Lumni"
            static let productDescription: String = NSLocalizedString("Descricao produto", comment: "")
            static let productPrice: String = "R$ 60"
        }
        enum Button {
            static let buyNow: String = NSLocalizedString("Comprar agora", comment: "")
        }
    }
    enum AETabBarViewController {
        enum TabBarItem {
            static let home: String = NSLocalizedString("Home", comment: "")
            static let scene: String = NSLocalizedString("Cenas", comment: "")
            static let store: String = NSLocalizedString("Loja", comment: "")
            static let settings: String = NSLocalizedString("Ajustes", comment: "")
        }
    }
    enum HomekitFacade {
        static let defaultHomeName: String = NSLocalizedString("Sua casa", comment: "")
    }
    
    enum AEIcon {
        enum Name {
            static let home: String = NSLocalizedString("Casa", comment: "")
            static let bathroom: String = NSLocalizedString("Banheiro", comment: "")
            static let kitchen: String = NSLocalizedString("Cozinha", comment: "")
            static let bedroom: String = NSLocalizedString("Quarto", comment: "")
            static let garage: String = NSLocalizedString("Garagem", comment: "")
            static let garden: String = NSLocalizedString("Jardim", comment: "")
            static let laundry: String = NSLocalizedString("Lavanderia", comment: "")
            static let office: String = NSLocalizedString("Escritório", comment: "")
            static let lamp: String = NSLocalizedString("Lâmpada", comment: "")
            static let wardrobe: String = NSLocalizedString("Closet", comment: "")
            static let living: String = NSLocalizedString("Sala", comment: "")
        }
    }
    
    enum SceneIconProvider {
        static let gameIcon: String = NSLocalizedString("Joystick", comment: "")
        static let goodMorning: String = NSLocalizedString("Sol", comment: "")
        static let sleep: String = NSLocalizedString("Lua", comment: "")
        static let gym: String = NSLocalizedString("Academia", comment: "")
        static let party: String = NSLocalizedString("Festa", comment: "")
        static let study: String = NSLocalizedString("Estudo", comment: "")
        static let work: String = NSLocalizedString("Trabalho", comment: "")
        static let arriveHome: String = NSLocalizedString("Chegar em casa", comment: "")
        static let leaveHome: String = NSLocalizedString("Sair de casa", comment: "")
    }
    
    enum EditSceneViewController {
        enum Carousel {
            static let title: String = "Scene's icon"
        }
        
        enum TextField {
            static let placeholder: String = "Scene's name"
        }
        enum Button {
            static let title: String = "Delete"
        }
    }
}
