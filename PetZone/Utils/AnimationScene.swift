import SpriteKit

class AnimationScene: SKScene {

    override func didMove(to view: SKView) {
        backgroundColor = .clear
        addLoginPet()
    }
    func addLoginPet() {
        let loginPet = SKSpriteNode(imageNamed: "LoginPet")
        let iconSize = CGSize(width: 30, height: 30)
        loginPet.size = iconSize
        loginPet.position = CGPoint(x: size.width / 2, y: size.height / 2)
        addChild(loginPet)

        let cartPosition = CGPoint(x: size.width - 60, y: size.height - 60)

        let scaleAction = SKAction.scale(to: 0.05, duration: 1.0)
        let moveAction = SKAction.move(to: cartPosition, duration: 1.0)

        let sequence = SKAction.sequence([moveAction, scaleAction])
        loginPet.run(sequence) { [weak self] in
            self?.removeFromParent()
        }
    }

}
