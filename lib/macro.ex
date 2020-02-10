defmodule Network do
  alias Cumatrix, as: CM

  @moduledoc """
  defnetwork generates neural network(nn)
  nn is list.
  e.g. [{:weight,w,lr,v},{:bias,b,lr},{:function,name}]
  each element is following.
  - weight
  {:weight,w,lr,v} w is matrix, lr is learning rate, v is for momentum,adagrad,adam
  - bias
  {:bias,b,lr,v} b is row vector
  - function
  {:function,name} 
  """
  defmacro defnetwork(name, do: body) do
    {_, _, [{arg, _, _}]} = name
    body1 = parse(body, arg)

    quote do
      def unquote(name) do
        unquote(body1)
      end
    end
  end

  # weight
  def parse({:w, _, [x, y]}, _) do
    quote do
      {:weight, CM.new(unquote(x), unquote(y), 0.1), 0.1, nil}
    end
  end

  def parse({:w, _, [x, y, lr]}, _) do
    quote do
      {:weight, CM.new(unquote(x), unquote(y), 0.1), unquote(lr), nil}
    end
  end

  def parse({:w, _, [x, y, lr, z]}, _) do
    quote do
      {:weight, CM.new(unquote(x), unquote(y), unquote(z)), unquote(lr), nil}
    end
  end

  # bias
  def parse({:b, _, [x]}, _) do
    quote do
      {:bias, CM.new(1, unquote(x), 0.0), 0.1, nil}
    end
  end

  def parse({:b, _, [x, lr]}, _) do
    quote do
      {:bias, CM.new(1, unquote(x), 0.0), unquote(lr), nil}
    end
  end

  # sigmoid
  def parse({:sigmoid, _, nil}, _) do
    quote do
      {:function, :sigmoid}
    end
  end

  # identity
  def parse({:ident, _, nil}, _) do
    quote do
      {:function, :ident}
    end
  end

  # relu
  def parse({:relu, _, nil}, _) do
    quote do
      {:function, :relu}
    end
  end

  # softmax
  def parse({:softmax, _, nil}, _) do
    quote do
      {:function, :softmax}
    end
  end

  def parse({x, _, nil}, _) do
    x
  end

  def parse({:|>, _, exp}, arg) do
    parse(exp, arg)
  end

  def parse([{arg, _, nil}, exp], arg) do
    [parse(exp, arg)]
  end

  def parse([exp1, exp2], arg) do
    Enum.reverse([parse(exp2, arg)] ++ Enum.reverse(parse(exp1, arg)))
  end

  def parse(x, _) do
    :io.write(x)
    raise "Syntax error in defnetwork"
  end
end
