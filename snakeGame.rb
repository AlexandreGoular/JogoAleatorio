require 'gosu'

class GameWindow < Gosu::Window
  def initialize
    super(640, 480)
    self.caption = "Movimente o Quadrado!"
    @square_size = 30 # Tamanho quadrado
    @square_x = (width - @square_size) / 2
    @square_y = (height - @square_size) / 2
    @maca_size = 20
    @maca_x = rand(width - @maca_size)
    @maca_y = rand(height - @maca_size)
    @pontuacao = 0
    @fonte = Gosu::Font.new(20)
    @meteoroTamanho = 40
    @meteoroLargura = rand(width - @meteoroTamanho - 1)
    @meteoroAltura = -@meteoroTamanho
    @meteoroVelocidade = 5
    @meteoro2Tamanho = 40
    @meteoro2Largura = rand(width - @meteoro2Tamanho - 1)
    @meteoro2Altura = -@meteoro2Tamanho
    @meteoro2Velocidade = 5
    @gameOver = false
  end

  def draw_rect(x, y, size, color)
    Gosu.draw_rect(x, y, size, size, color)
  end

  def button_down(id)
    if id == Gosu::KB_R && @gameOver
      @gameOver = false
      @square_x = (width - @square_size) / 2
      @square_y = (height - @square_size) / 2
      @meteoroLargura = rand(width - @meteoroTamanho)
      @meteoroAltura = -@meteoroTamanho
      @meteoro2Largura = rand(width - @meteoro2Tamanho)
      @meteoro2Altura = -@meteoro2Tamanho
      @pontuacao = 0
    end
  end
  
  

  def update
    return if @gameOver
    move_square(-2, 0) if Gosu.button_down?(Gosu::KB_LEFT) || Gosu.button_down?(Gosu::GP_LEFT)
    move_square(2, 0) if Gosu.button_down?(Gosu::KB_RIGHT) || Gosu.button_down?(Gosu::GP_RIGHT)
    move_square(0, -2) if Gosu.button_down?(Gosu::KB_UP) || Gosu.button_down?(Gosu::GP_UP)
    move_square(0, 2) if Gosu.button_down?(Gosu::KB_DOWN) || Gosu.button_down?(Gosu::GP_DOWN)

    @meteoroAltura += @meteoroVelocidade

    @meteoro2Altura += @meteoro2Velocidade

    if collision?(@square_x, @square_y, @square_size, @meteoro2Largura, @meteoro2Altura, @meteoro2Tamanho)
        @meteoro2Largura = rand(width - @meteoro2Tamanho)
        @meteoro2Altura = -@meteoro2Tamanho
        @gameOver = true
    end

    if collision?(@square_x, @square_y, @square_size, @maca_x, @maca_y, @maca_size)
      @maca_x = rand(width - @maca_size)
      @maca_y = rand(height - @maca_size)
      @pontuacao += 1
    end

    if collision?(@square_x, @square_y, @square_size, @meteoroLargura, @meteoroAltura, @meteoroTamanho) #Isso vera se a cobra colidiu com o meteoro
        @square_x = (width - @square_size) / 2
        @square_y = (height - @square_size) / 2
        @meteoroLargura = rand(width - @meteoroTamanho)
        @meteoroAltura = -@meteoroTamanho
        @pontuacao = 0
        @gameOver = true
    end

    if @meteoro2Altura > height
        @meteoro2Largura = rand(width - @meteoro2Tamanho)
        @meteoro2Altura = -@meteoro2Tamanho
      end

    if @meteoroAltura > height #Caso a cobra não colida ela seguira Viagem
        @meteoroLargura = rand(width - @meteoroTamanho)
        @meteoroAltura = -@meteoroTamanho
    end
  end

  def draw

    if @gameOver
        draw_gameOver_screen
    end 
    draw_rect(@square_x, @square_y, @square_size, Gosu::Color::GREEN)
    draw_rect(@maca_x, @maca_y, @maca_size, Gosu::Color::RED)
    draw_rect(@meteoroLargura, @meteoroAltura, @meteoroTamanho, Gosu::Color::YELLOW)
    @fonte.draw("Pontuação: #{@pontuacao}", 10, 10, 1)
    draw_rect(@meteoro2Largura, @meteoro2Altura, @meteoro2Tamanho, Gosu::Color::YELLOW)
  end

  def draw_gameOver_screen
    gameOverText = ("Você perdeu!! Pressione R para jogar Novamente")
    @fonte.draw(gameOverText, (width - @fonte.text_width(gameOverText)) / 2, height / 2, 1, 1, 1, Gosu::Color::RED)
  end

  private

  def move_square(x_change = 1, y_change = 0)
    new_x = @square_x + x_change
    new_y = @square_y + y_change

    if new_x >= 0 && new_x <= (width - @square_size) && new_y >= 0 && new_y <= (height - @square_size)
      @square_x = new_x
      @square_y = new_y
      
    end
  end

  def collision?(x1, y1, size1, x2, y2, size2)
    x1 < x2 + size2 &&
      x1 + size1 > x2 &&
      y1 < y2 + size2 &&
      y1 + size1 > y2
  end
end

GameWindow.new.show
