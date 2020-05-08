defmodule IconeIdentidade do
  @moduledoc """
  Documentation for `IconeIdentidade`.
  """

  def main(input) do
    input
    |>hash
    |>criar_cor
    |>criartable
    |>rmvimpar
    |>gerapixel
    |>desenhar
    |>salvar input
  end
  
  def salvar imagem,input do
    File.write("#{input}.png",imagem)
  end
  def desenhar (%Imagem{color: cor, pixel_map: pixel_map}) do
    imagem = :egd.create(250,250)
    preencher = :egd.color(cor)

    Enum.each pixel_map, fn{start, stop} ->
      :egd.filledRectangle(imagem,start,stop,preencher)
    end
    :egd.render(imagem)
  end

  def gerapixel %Imagem{grid: grid} = imagem do
    pixel_map = Enum.map grid, fn{_valor, index} ->
      hor = rem(index, 5) * 50
      ver = div(index, 5) * 50
      t_esquerda = {hor, ver}
      i_direita = {hor+50, ver+50}
      {t_esquerda,i_direita}
    end
    %Imagem{imagem| pixel_map: pixel_map}
  end

  def criar_cor(%Imagem{ hex: [r, g, b | _tail]} = imagem) do
    
    %Imagem{ imagem | color: {r,g,b}}
  end

  def criartable(%Imagem{hex: hex} = imagem) do
    grid = hex
    |> Enum.chunk(3)
    |> Enum.map(&espelhar/1)
    |> List.flatten
    |> Enum.with_index
    %Imagem{imagem | grid: grid}
  end

  def rmvimpar(%Imagem{grid: grid } = imagem) do
     new_grid = Enum.filter grid,fn {valor, _indice} ->
      rem(valor,2) == 0
    end
    %Imagem{imagem | grid: new_grid}
  end

  def espelhar(linha) do
    [prim,sec | _tail] = linha
    linha ++ [sec,prim]
  end

  def hash(input) do
    hex = :crypto.hash(:md5, input)
    |> :binary.bin_to_list
    %Imagem{hex: hex}
  end
end
