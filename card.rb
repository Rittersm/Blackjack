class Card

  attr_accessor :face, :suit, :value

  def initialize(face, suit)
    @face = face
    @suit = suit
    face_value
  end

  def face_value
    if face == "J"
      self.value = 10
    elsif face == "Q"
      self.value = 10
    elsif face == "K"
      self.value = 10
    elsif face == "A"
      self.value = 11
    else
      self.value = face.to_i
    end
  end

  def to_s
    "#{face} of #{suit}"
  end

end
