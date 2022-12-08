require_relative "data"

# ROCK = :rock
# PAPER = :paper
# SCISSORS = :scissors

# LETTERS = {
#   "A" => ROCK,
#   "B" => PAPER,
#   "C" => SCISSORS,
#   "X" => ROCK,
#   "Y" => PAPER,
#   "Z" => SCISSORS,
# }

def outcome_score(oponent, yourself)
  if oponent == yourself
    3
  elsif oponent == ROCK && yourself == PAPER
    6
  elsif oponent == ROCK && yourself == SCISSORS
    0
  elsif oponent == PAPER && yourself == ROCK
    0
  elsif oponent == PAPER && yourself == SCISSORS
    6
  elsif oponent == SCISSORS && yourself == ROCK
    6
  elsif oponent == SCISSORS && yourself == PAPER
    0
  end
end

def choice_score(yourself)
  if yourself == ROCK
    1
  elsif yourself == PAPER
    2
  elsif yourself == SCISSORS
    3
  end
end

# scores = DATA.map do |round|
#   outcome_score(LETTERS[round[0]], LETTERS[round[1]]) + choice_score(LETTERS[round[1]])
# end

# p scores.sum


ROCK = :rock
PAPER = :paper
SCISSORS = :scissors

LETTERS = {
  "A" => ROCK,
  "B" => PAPER,
  "C" => SCISSORS,
}

WINNING_CHOICE = {
  ROCK => PAPER,
  PAPER => SCISSORS,
  SCISSORS => ROCK,
}

INDICATIONS = {
  "X" => :lose,
  "Y" => :draw,
  "Z" => :win
}

def compute_choice(oponent, indication)
  if indication == :draw
    oponent
  elsif indication == :win
    WINNING_CHOICE[oponent]
  elsif indication == :lose
    WINNING_CHOICE.key(oponent)
  end
end

scores = DATA.map do |round|
  oponent_choice = LETTERS[round[0]]
  your_choice = compute_choice(oponent_choice, INDICATIONS[round[1]])

  outcome_score(oponent_choice, your_choice) + choice_score(your_choice)
end

p scores.sum
