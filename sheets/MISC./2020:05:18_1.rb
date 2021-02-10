
live_loop :foo do
  use_synth :tb303
  use_bpm 70
  with_fx :ixi_techno, room: rrand(0,1) do
    16.times do
      play 36, release: 0.1, cutoff: rrand(60, 130)
      sleep 0.125
    end
    15.times do
      play 37, release: 0.1, cutoff: rrand(60, 100)
      sleep 0.125
    end
    play 39, release: 0.1, cutoff: rrand(60, 100)
    play 51, release: 0.1, cutoff: rrand(60, 130)
    sleep 0.125
  end
stop
end

live_loop :bd, sync: :foo do
  use_bpm 140
  4.times do
    sample :bd_tek,attack: 0.01, sustain: 0.1, release: 0.1
    sleep 1
  end

end

live_loop :perc1, sync: :bd do
  use_bpm 140
  sleep 0.5
  sample :drum_cymbal_soft,attack: 0.01, sustain: 0, release: 0.1
  ##| sleep 0.5
  ##| sample :drum_cymbal_soft,attack: 0.01, sustain: 0, release: 0.1
  sleep 0.25
  sample :drum_cymbal_soft,attack: 0.01, sustain: 0, release: 0.1
  sleep 0.25
stop
end

live_loop :perc2, sync: :bd do
  use_bpm 140
  sleep 1
  sample :drum_cymbal_pedal, release: 0.1
  sleep 1
stop
end

live_loop :perc3, sync: :bd do
  use_bpm 140
  sleep 7
  sample :tabla_dhec
  sleep 0.75
  sample :tabla_dhec
  sleep 0.25
stop
end
