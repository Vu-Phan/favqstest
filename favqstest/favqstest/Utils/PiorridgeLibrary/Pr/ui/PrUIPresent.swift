//
//  SlideUpInteraction.swift
//  Porridge
//
//  Created by Vu Phan on 20/05/2019.
//  Copyright © 2019 Vu Phan. All rights reserved.
//

import UIKit

/*
    == EXAMPLE ==
    -SourceVC-
        // - need to be referenced
        var prTransitioningDelegate = Pr.present.transitioningDelegate.init(to: .fadeIn, drag: true)
        func toShow() {
            let toShowVC = ToShowVC.init()
            toShowVC.transitioningDelegate = prTransitioningDelegate
            toShowVC.modalPresentationStyle = .custom
            present(toShowVC, animated: true, completion: nil)
        }
    -ToShowVC-
		private func setupDismissGesture() {
			let tapGesture = UITapGestureRecognizer.init(target: self, action: #selector(self.dismissVC))
			tapDismissBgView.addGestureRecognizer(tapGesture)

			let panGesture = UIPanGestureRecognizer.init(target: self, action: #selector(self.dismissDragVC(_:)))
			tapDismissBgView.addGestureRecognizer(panGesture)
		}

		@objc func dismissVC() {
			self.dismiss(animated: true, completion: nil)
		}

		@objc func dismissDragVC(_ sender: UIPanGestureRecognizer) {
			if let transitioningDelegate = self.transitioningDelegate as? Pr.present.transitioningDelegate {
				transitioningDelegate.interactor?.handleInteractor(from: sender, vc: self)
			}
		}
*/

public extension Pr {
	class present: NSObject {
		// MARK: - Animation Enum
		public class animatedTransition {
			public enum Effect {
				case unknown
				case slideUp
				case slideDown
				case slideLeft
				case slideRight
				case slideAll
				case fadeIn
				case fadeOut

			}
			public enum Interaction {
				case present
				case dismiss
			}

			public static func inverseEffect(_ effect: Effect) -> Effect {
				var newEffect:Effect!

				switch effect {
				case .slideUp:
					newEffect = .slideDown
				case .slideDown:
					newEffect = .slideUp
				case .slideLeft:
					newEffect = .slideRight
				case .slideRight:
					newEffect = .slideLeft
				case .fadeIn:
					newEffect = .fadeOut
				case .fadeOut:
					newEffect = .fadeIn
				default:
					newEffect = .unknown
				}

				return newEffect
			}
		}


		// MARK: - Transioning Delegate
		public class transitioningDelegate: NSObject, UIViewControllerTransitioningDelegate {
			public var interactor:slideDismissInteractor?
			private var toEffect:animatedTransition.Effect = .slideUp
			private var fromEffect:animatedTransition.Effect = .slideDown

			public init(to: animatedTransition.Effect, from: animatedTransition.Effect? = nil, drag: Bool = false) {
				toEffect = to
				fromEffect = animatedTransition.inverseEffect(toEffect)
				if let from = from {
					fromEffect = from
				}

				if drag {
					interactor = slideDismissInteractor.init(direction: fromEffect)
				}
			}

			public func animationController(forPresented presented: UIViewController,
											presenting: UIViewController,
											source: UIViewController)
				-> UIViewControllerAnimatedTransitioning? {
					return AnimationController.init(interaction: .present, effect: toEffect)
			}

			public func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
				return AnimationController.init(interaction: .dismiss, effect: fromEffect)
			}

			// MARK: __ Dismiss drag interaction
			public func interactionControllerForDismissal(using animator: UIViewControllerAnimatedTransitioning) -> UIViewControllerInteractiveTransitioning? {
				if let interactor = interactor {
					return interactor.hasStarted ? interactor : nil
				}
				return nil
			}

			// Handle pan gesture to call in the dismiss ViewController for control drag interaction
			func dragHandler(from panGesture: UIPanGestureRecognizer, forVC: UIViewController) {
				interactor?.handleInteractor(from: panGesture, vc: forVC)
			}
		}

		// MARK: - Drag Interactor
		public class slideDismissInteractor: UIPercentDrivenInteractiveTransition {
			public var hasStarted = false
			public var shouldFinish = false
			public var dragDirection: animatedTransition.Effect = .slideUp

			public init(direction: animatedTransition.Effect) {
				super.init()
				dragDirection = direction
			}

			public func handleInteractor(from panGesture: UIPanGestureRecognizer, vc: UIViewController) {
				let percentThreshold:CGFloat = 0.2
				let translation = panGesture.translation(in: vc.view)
				var direction: CGFloat!
				var invert:CGFloat = 1

				let dragVertical = translation.y / vc.view.bounds.height
				let dragHorizontal = translation.x / vc.view.bounds.width

				switch dragDirection {
				case .slideUp:
					direction = dragVertical
					invert = -1
				case .slideLeft:
					direction = dragHorizontal
				case .slideRight:
					direction = dragHorizontal
					invert = -1
				case .slideDown, .fadeOut:
					direction = dragVertical
				default:
					direction = 0
				}

				let movement:Float = fmaxf(Float(direction * invert), 0.0)
				let movementPercent:Float = fminf(Float(movement), 1.0)
				let progress = CGFloat(movementPercent)

				switch panGesture.state {
				case .began:
					hasStarted = true
					vc.dismiss(animated: true, completion: nil)
				case .changed:
					shouldFinish = progress > percentThreshold
					self.update(progress)
				case .cancelled:
					hasStarted = false
					self.cancel()
				case .ended:
					hasStarted = false
					shouldFinish ? self.finish() : self.cancel()
				default:
					break
				}
			}
		}


		// MARK: -
		// MARK: - Effect Animated Transitioning
		public class AnimationController: NSObject, UIViewControllerAnimatedTransitioning {
			private struct TransitionContextM {
				var transitionVC = UIViewController()
				var containerView = UIView()
				var animationDuration = TimeInterval()
			}
			private var transitionDuration:TimeInterval = 0.50
			private var bgClearColor = UIColor.init(white: 0, alpha: 0)
			private var bgOverlayColor = UIColor.init(white: 0, alpha: 0.7)
            private var bgFadeInColor = UIColor.init(white: 0, alpha: 0.0)
			//
			private var effect:animatedTransition.Effect = .slideUp
			private var interaction:animatedTransition.Interaction = .present


			// MARK: __ Setup
			init(interaction: animatedTransition.Interaction, effect: animatedTransition.Effect) {
				self.interaction = interaction
				self.effect = effect
			}

			init(interaction: animatedTransition.Interaction, effect: animatedTransition.Effect, duration: TimeInterval, overlayColor: UIColor? = nil) {
				self.interaction = interaction
				self.effect = effect
				self.transitionDuration = duration
				if let overlayColor = overlayColor {
					self.bgOverlayColor = overlayColor
				}
			}

			public func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
				return transitionDuration
			}

			public func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
				switch effect {
				case .slideDown, .slideUp, .slideLeft, .slideRight:
					handleSlideTransition(transitionContext: transitionContext)
				case .fadeIn, .fadeOut:
					handleFadeTransition(transitionContext: transitionContext)
				default:
					print("")
				}
			}

			private func setupTransitionContext(fromTransitionContext: UIViewControllerContextTransitioning) -> TransitionContextM {
				var transitionVC = fromTransitionContext.viewController(forKey: UITransitionContextViewControllerKey.to)!
				if interaction == .dismiss {
					transitionVC = fromTransitionContext.viewController(forKey: UITransitionContextViewControllerKey.from)!
				}
				let containerView = fromTransitionContext.containerView
				let animationDuration = transitionDuration(using: fromTransitionContext)
				transitionVC.view.frame = containerView.frame

				if interaction == .present {
					containerView.addSubview(transitionVC.view)
				}

				return TransitionContextM.init(transitionVC: transitionVC, containerView: containerView, animationDuration: animationDuration)
			}

			// MARK: __ __ Slide
			private func handleSlideTransition(transitionContext: UIViewControllerContextTransitioning) {
				let context = setupTransitionContext(fromTransitionContext: transitionContext)

				let transitionVCTransform:((animatedTransition.Interaction) -> Void) = { (interaction) in
					var invert:CGFloat = 1
					if interaction == .dismiss {
						invert = -1
					}

					var x:CGFloat = 0
					var y:CGFloat = 0
					switch self.effect {
					case .slideDown:
						y = -context.containerView.bounds.height * invert
					case .slideLeft:
						x = -context.containerView.bounds.width * invert
					case .slideRight:
						x = context.containerView.bounds.width * invert
					default:
						y = context.containerView.bounds.height * invert
					}
					context.transitionVC.view.transform = CGAffineTransform(translationX: x, y: y)
				}

				if interaction == .dismiss {
					context.containerView.backgroundColor = bgOverlayColor

					UIView.animate(withDuration: context.animationDuration, animations: {
						transitionVCTransform(self.interaction)
						context.containerView.backgroundColor = self.bgClearColor
					}) { finished in
						transitionContext.completeTransition(!transitionContext.transitionWasCancelled)
					}
				} else {
					transitionVCTransform(interaction)
					context.containerView.backgroundColor = UIColor.init(white: 0, alpha: 0.0)
					UIView.animate(withDuration: context.animationDuration, animations: {
						context.transitionVC.view.transform = CGAffineTransform.identity
						context.containerView.backgroundColor = self.bgOverlayColor
					}, completion: { finished in
						transitionContext.completeTransition(finished)
					})
				}
			}

			// MARK: __ __ Fade
			func handleFadeTransition(transitionContext: UIViewControllerContextTransitioning) {
				let context = setupTransitionContext(fromTransitionContext: transitionContext)

				if interaction == .dismiss {
					context.transitionVC.view.alpha = 1.0
					context.containerView.backgroundColor = bgFadeInColor
					UIView.animate(withDuration: context.animationDuration, animations: {
						context.transitionVC.view.alpha = 0.0
						context.containerView.backgroundColor = self.bgClearColor
					}) { finished in
						transitionContext.completeTransition(!transitionContext.transitionWasCancelled)
					}
				} else {
					context.transitionVC.view.alpha = 0.0
					context.containerView.backgroundColor = bgClearColor
					UIView.animate(withDuration: context.animationDuration, animations: {
						context.transitionVC.view.alpha = 1.0
						context.containerView.backgroundColor = self.bgFadeInColor
					}, completion: { finished in
						transitionContext.completeTransition(finished)
					})
				}
			}
		}
	}

}
