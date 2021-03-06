defmodule CumatrixTest do
  use ExUnit.Case
  doctest Cumatrix

  test "matrix" do
    assert Cumatrix.new([[1.0, 2.0], [3.0, 4.0]]) ==
             {2, 2, <<0, 0, 128, 63, 0, 0, 64, 64, 0, 0, 0, 64, 0, 0, 128, 64>>}

    m = Cumatrix.new([[1.0, 2.0], [3.0, 4.0]])
    assert Cumatrix.add(m, m) == Cumatrix.new([[2.0, 4.0], [6.0, 8.0]])
    assert Cumatrix.sub(m, m) == Cumatrix.new([[0.0, 0.0], [0.0, 0.0]])
    assert Cumatrix.mult(m, m) == Cumatrix.new([[7.0, 10.0], [15.0, 22.0]])
    assert Cumatrix.new(2, 3) == Cumatrix.new([[0.0, 0.0, 0.0], [0.0, 0.0, 0.0]])
    assert Cumatrix.new(2, 3, 0.1) == Cumatrix.new([[0.1, 0.1, 0.1], [0.1, 0.1, 0.1]])
    assert Cumatrix.elt(m, 1, 2) == 2.0
    assert Cumatrix.size(m) == {2, 2}
    m1 = Cumatrix.new([[1.0, -2.0, 3.0], [4.0, 5.0, -6.0]])
    assert Cumatrix.emult(m1, m1) == Cumatrix.new([[1.0, 4.0, 9.0], [16.0, 25.0, 36.0]])
    assert Cumatrix.sum(m) == 10.0
    assert Cumatrix.trace(m) == 5.0
    assert Cumatrix.ident(3) == Cumatrix.new([[1.0, 0.0, 0.0], [0.0, 1.0, 0.0], [0.0, 0.0, 1.0]])
    assert Cumatrix.transpose(m1) == Cumatrix.new([[1.0, 4.0], [-2.0, 5.0], [3.0, -6.0]])
    m2 = Cumatrix.new([[1010.0, 1000.0, 990.0], [1010.0, 1000.0, 990.0]])

    assert Cumatrix.activate(m2, :softmax) |> Cumatrix.to_list() ==
             [
               [
                 0.9900544881820679,
                 4.494840686675161e-5,
                 2.040654534241071e-9
               ],
               [
                 0.9900544881820679,
                 4.494840686675161e-5,
                 2.040654534241071e-9
               ]
             ]

    assert Cumatrix.mult(2.0, m1) == Cumatrix.new([[2.0, -4.0, 6.0], [8.0, 10.0, -12.0]])
    assert Cumatrix.mult(m1, 2.0) == Cumatrix.new([[2.0, -4.0, 6.0], [8.0, 10.0, -12.0]])
    m3 = Cumatrix.new([[1.0, 2.0]])
    assert Cumatrix.add(m, m3) == Cumatrix.new([[2.0, 4.0], [4.0, 6.0]])
    assert Cumatrix.to_list(m1) == [[1.0, -2.0, 3.0], [4.0, 5.0, -6.0]]
    assert Cumatrix.set(m1, 2, 3, 1.0) == Cumatrix.new([[1.0, -2.0, 3.0], [4.0, 5.0, 1.0]])
    m4 = Cumatrix.new([[1.0, 2.0, 3.0], [2.0, 3.0, 1.2]])
    m5 = Cumatrix.new([[1.1, 2.9, 2.0], [2.2, 3.1, 1.2]])
    assert Cumatrix.loss(m4, m5, :square) == 0.4675000309944153
    assert Cumatrix.loss(m4, m5, :cross) == -4.678380012512207
    m6 = Cumatrix.new([[0.1, 0.9, 0.1], [0.2, 0.1, 1.2]])

    assert Cumatrix.activate(m6, :sigmoid) ==
             Cumatrix.new([
               [0.5249791741371155, 0.7109494805335999, 0.5249791741371155],
               [0.5498339533805847, 0.5249791741371155, 0.7685248255729675]
             ])

    assert Cumatrix.activate(m6, :tanh) ==
             Cumatrix.new([
               [0.0996680036187172, 0.7162978649139404, 0.0996680036187172],
               [0.1973753273487091, 0.0996680036187172, 0.8336546421051025]
             ])

    assert Cumatrix.activate(m6, :relu) ==
             Cumatrix.new([
               [0.10000000149011612, 0.8999999761581421, 0.10000000149011612],
               [0.20000000298023224, 0.10000000149011612, 1.2000000476837158]
             ])

    assert Cumatrix.average(m6) ==
             Cumatrix.new([[0.15000000596046448, 0.5, 0.6500000357627869]])

    t1 = Cumatrix.new([[[[1.0, 2.0, 3.0], [4.0, 5.0, 6.0], [7.0, 8.0, 9.0]]]])
    f1 = Cumatrix.new([[[1.0, 2.0], [3.0, 4.0]]])
    t2 = Cumatrix.new([[[[2.0, 3.0], [4.0, 5.0]]]])

    assert Cumatrix.convolute(t1, f1, 1, 0) == Cumatrix.new([[[[37.0, 47.0], [67.0, 77.0]]]])

    assert Cumatrix.convolute(t1, f1, 1, 0) |> Cumatrix.to_list() == [
             [[[37.0, 47.0], [67.0, 77.0]]]
           ]

    assert Cumatrix.deconvolute(t2, f1, 1, 0) |> Cumatrix.to_list() ==
             [[[[2.0, 7.0, 6.0], [10.0, 30.0, 22.0], [12.0, 31.0, 20.0]]]]

    assert Cumatrix.gradfilter(t1, f1, t2, 1, 0) |> Cumatrix.to_list() ==
             Cumatrix.new([[[49.0, 63.0], [91.0, 105.0]]]) |> Cumatrix.to_list()

    t3 =
      Cumatrix.new([
        [[[1.0, 2.0, 3.0, 3.3], [7.0, 4.0, 5.0, 6.0], [1.1, 7.0, 8.0, 9.0], [1.2, 1.3, 1.4, 1.0]]]
      ])

    t4 = Cumatrix.new([[[[0.1, 0.2], [0.3, 0.4]]]])
    {f, b} = Cumatrix.pooling(t3, 2)
    assert f |> Cumatrix.to_list() == [[[[7.0, 6.0], [7.0, 9.0]]]]
    assert b |> Cumatrix.to_list() == [[[[1.0e3, 1003.0], [2001.0, 2003.0]]]]

    assert Cumatrix.unpooling(b, t4, 2) |> Cumatrix.to_list() ==
             Cumatrix.new([
               [
                 [
                   [0.0, 0.0, 0.0, 0.0],
                   [0.1, 0.0, 0.0, 0.2],
                   [0.0, 0.3, 0.0, 0.4],
                   [0.0, 0.0, 0.0, 0.0]
                 ]
               ]
             ])
             |> Cumatrix.to_list()

    t4 =
      Cumatrix.new([
        [1.0, 2.0, 3.0, 3.3, 7.0, 4.0, 5.0, 6.0, 1.1, 7.0, 8.0, 9.0, 1.2, 1.3, 1.4, 1.0]
      ])

    assert Cumatrix.full(t3) == t4

    assert Cumatrix.unfull(t4, 4, 4) == t3

    t5 =
      Cumatrix.new([
        [
          [[1.0, 2.0, 3.0], [4.0, 5.0, 6.0], [7.0, 8.0, 9.0]],
          [[10.0, 11.0, 12.0], [13.0, 14.0, 15.0], [16.0, 17.0, 18.0]]
        ]
      ])

    f5 = Cumatrix.new([[[1.0, 1.0], [1.0, 1.0]], [[1.0, 1.0], [1.0, 1.0]]])
    l5 = Cumatrix.new([[[[0.1, 0.2], [0.3, 0.4]]]])

    assert Cumatrix.convolute(t5, f5, 1, 0) |> Cumatrix.to_list() == [
             [[[60.0, 68.0], [84.0, 92.0]]]
           ]

    assert Cumatrix.convolute(t5, f5, 1, 1) |> Cumatrix.to_list() ==
             [
               [
                 [
                   [11.0, 24.0, 28.0, 15.0],
                   [28.0, 60.0, 68.0, 36.0],
                   [40.0, 84.0, 92.0, 48.0],
                   [23.0, 48.0, 52.0, 27.0]
                 ]
               ]
             ]

    assert Cumatrix.deconvolute(l5, f5, 1, 0) |> Cumatrix.to_list() ==
             [
               [
                 [
                   [0.20000000298023224, 0.6000000238418579, 0.4000000059604645],
                   [0.800000011920929, 2.000000238418579, 1.2000000476837158],
                   [0.6000000238418579, 1.399999976158142, 0.800000011920929]
                 ]
               ]
             ]

    f6 = Cumatrix.new([[[1.0, 2.0], [3.0, 4.0]], [[5.0, 6.0], [7.0, 8.0]]])

    assert Cumatrix.deconvolute(l5, f6, 1, 0) |> Cumatrix.to_list() ==
             [
               [
                 [
                   [0.6000000238418579, 2.0, 1.600000023841858],
                   [2.8000001907348633, 8.0, 5.599999904632568],
                   [3.0, 7.600000381469727, 4.800000190734863]
                 ]
               ]
             ]

    assert Cumatrix.deconvolute(l5, f5, 2, 0) |> Cumatrix.to_list() ==
             [
               [
                 [
                   [
                     0.20000000298023224,
                     0.20000000298023224,
                     0.4000000059604645,
                     0.4000000059604645
                   ],
                   [
                     0.20000000298023224,
                     0.20000000298023224,
                     0.4000000059604645,
                     0.4000000059604645
                   ],
                   [
                     0.6000000238418579,
                     0.6000000238418579,
                     0.800000011920929,
                     0.800000011920929
                   ],
                   [
                     0.6000000238418579,
                     0.6000000238418579,
                     0.800000011920929,
                     0.800000011920929
                   ]
                 ]
               ]
             ]

    assert Cumatrix.deconvolute(l5, f6, 2, 0) |> Cumatrix.to_list() ==
             [
               [
                 [
                   [0.6000000238418579, 0.800000011920929, 1.2000000476837158, 1.600000023841858],
                   [1.0, 1.2000000476837158, 2.0, 2.4000000953674316],
                   [
                     1.8000000715255737,
                     2.4000000953674316,
                     2.4000000953674316,
                     3.200000047683716
                   ],
                   [3.0, 3.6000001430511475, 4.0, 4.800000190734863]
                 ]
               ]
             ]

    assert Cumatrix.add_diff(f6, 1, 1, 1, 0.001) |> Cumatrix.to_list() ==
             [[[1.0010000467300415, 2.0], [3.0, 4.0]], [[5.0, 6.0], [7.0, 8.0]]]

    assert Cumatrix.add_diff(m1, 1, 1, 0.001) |> Cumatrix.to_list() ==
             [[1.0010000467300415, -2.0, 3.0], [4.0, 5.0, -6.0]]
  end
end
