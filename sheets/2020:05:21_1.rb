
bpm = 120
live_loop :metro do
  use_bpm bpm
  with_fx :echo, phase: 0.25, mix: 1, decay: 4 do
    with_fx :lpf, cutoff: 80, amp: 0.3 do
      sample :bd_ada,
        amp: 3 if spread(1,4).tick
    end
  end
  sleep 4
  ##| stop
end

with_fx :reverb,amp: 1, room: 0.5,mix: 0.7 do
  live_loop :main, sync: :metro do
    use_synth :beep
    use_bpm bpm
    with_fx :echo, phase: 0.125, mix: 0.2 do
      with_fx :lpf, mix: 1, amp: 0.5, cutoff: 60 do
        pref_chord = choose([:e3, :a3, :e4, :a4])
        chord_tone = :m7
        player_1 = play choose(chord(pref_chord, chord_tone)),
          release: rrand(0.01, 0.5), amp: 2.3, vel: 0.2, hard: 0.4
        player_2 = play choose(chord(pref_chord - 12, chord_tone)),
          release: rrand(0.5, 0.5), amp: 1, vel: 0.2, hard: 0.4
        player_3 = play choose(chord(pref_chord + 12, chord_tone)),
          release: rrand(0.1, 0.3), amp: 1, vel: 0.2, hard: 0.4
        if one_in(2)
          player_1
          player_2
          player_3
        else
          sleep choose([0.25, 0.5, 1])
        end
        sleep choose([0.25, 0.5])
      end
    end
    ##| stop
  end
end


with_fx :reverb, amp: 2, room: 1 do
  live_loop :background, sync: :metro do
    use_bpm bpm
    with_fx :lpf, cutoff: 50 do
      use_synth :piano
      release_time = rrand_i(2,10)
      sustain_time = rrand_i(2,8)
      pref_chord = choose([:a5, :e5,:a6, :e6])
      chord_tone = :m
      player_1 = play_chord chord(pref_chord, chord_tone),
        release: release_time,sustain: sustain_time, amp: 2, vel: 0.2, hard: 0.3
      player_2 = play_chord chord(pref_chord -12, chord_tone),
        release: release_time,sustain: sustain_time, amp: 2, vel: 0.2, hard: 0.3
      if one_in(3)
        player_1
        player_2
      end
      sleep release_time
    end
    ##| stop
  end
end

with_fx :reverb, room: 1 do
  live_loop :bass, sync: :metro do
    use_bpm bpm
    with_fx :lpf, cutoff: 60 ,amp: 0.5 do
      use_synth :piano
      4.times do
        play :e2,attack: 0.2 ,sustain: 2,release: 2, hard: 0.3, amp: 0.5
        sleep 4
      end
      4.times do
        play :a2,attack: 0.2,  sustain: 2, release: 2, hard: 0.3, amp: 0.5
        sleep 4
      end
    end
  end
end

with_fx :reverb ,room: 0.5 do
  live_loop :bd, sync: :metro do
    use_bpm bpm
    with_fx :lpf, cutoff: 80, amp: 0.3 do
      sample :bd_ada,
        amp: 3 if spread(1,4).tick
    end
    with_fx :lpf, cutoff: 70 do
      sample :tabla_dhec if spread(1,4).rotate(2).look
    end
    with_fx :lpf, cutoff: 90 do
      sample :bd_ada,
        attack: 0,sustain: 0.1, release: 0.1,amp: 1 if spread(1,32).rotate(7).look
    end
    sleep 0.25
    ##| stop
  end
end

