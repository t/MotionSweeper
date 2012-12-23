
class MainController < UIViewController

  def viewDidLoad
    super

    @x_count = 17
    @y_count = 17
    @mine_count = 20
    
    @cells  = []
    @mines  = {}
    @opened = {}

    self.view.backgroundColor = UIColor.whiteColor

    @tile1 = UIImage.imageNamed("tile1.gif")
    @tile2 = UIImage.imageNamed("tile2.gif")

    @y_count.times{|y|
      @x_count.times{|x| 

        button = UIButton.buttonWithType UIButtonTypeCustom
        button.frame = [[x * 18 + 6, y * 18 + 6], [18, 18]]
        button.setBackgroundImage(@tile1, forState: UIControlStateNormal)
        button.addTarget(self, action: 'onClicked:', forControlEvents: UIControlEventTouchUpInside)
        button.tag = y * @y_count + x
        @cells.push(button)

        view.addSubview(button)
      }
    }

    @mine_count.times{|i|
      while true
        r = rand(@y_count * @x_count) 
        unless @mines[r]
          @mines[r] = true
          break
        end
      end
    }

  end

  def onClicked(sender)
    y, x = sender.tag.divmod(@y_count)
    if( open_cell(x, y) )
      open_all_cell()
      App.alert("Game Over!")
    end
  end

  def open_cell(x, y)
    return false unless (x >= 0 && x < @x_count && y >= 0 && y < @y_count)
 
    idx  = @y_count * y + x
    cell = @cells[idx]
    return false unless cell
    
    return if @opened[idx]

    v = get_value(x, y)

    cell.setBackgroundImage(@tile2, forState: UIControlStateNormal)
    cell.setTitle(v, forState: UIControlStateNormal)
    @opened[idx] = true

    if(v == "")
      open_cell(x, y - 1)
      open_cell(x + 1, y) 
      open_cell(x, y + 1)
      open_cell(x - 1, y)
    end

    return (v == "X")
  end

  def open_all_cell
    @y_count.times{|y|
      @x_count.times{|x|
        if is_mine(x, y)
          open_cell(x, y)
        end
      }
    }
  end

  def get_value(x, y)
    if is_mine(x, y)
      return "X"
    else
      count = 0;
      for i in -1..1
        for j in -1..1
          if(is_mine(x + i, y + j))
            count += 1
          end
        end
      end
      if(count == 0)
        return ""
      else
        return count.to_s
      end
    end
  end

  def is_mine(x, y)
    return @mines[y * @y_count + x]; 
  end

end

