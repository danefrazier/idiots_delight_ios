# Idiot's Delight — iOS

Native iOS port of [Idiot's Delight](https://github.com/danefrazier/idiots_delight), a single-player solitaire card game.

Built with Swift and SwiftUI.

## Game Rules

- 52-card deck, no jokers. Aces are high.
- Cards are dealt face-up into 4 stacks, one card per stack per round.
- Remove the lowest showing card when two or more cards of the same suit are visible.
- Aces may be moved freely between stacks.
- Win by reducing each stack to a single ace.

## Project Structure

```
IdiotsDelight/
  Models/
    Card.swift
    Deck.swift
    GameState.swift
  Views/
    ContentView.swift
    GameView.swift
    StackColumnView.swift
    CardView.swift
    AceMoveOverlay.swift
    WinView.swift
    LoseView.swift
  Resources/
    Assets.xcassets
```

## Status

Scaffolding in progress. See `idiots_delight_specification.txt` for full design spec including model mapping, view layer, interaction model, and effort estimates.

## Reference

Original Python CLI implementation: https://github.com/danefrazier/idiots_delight
