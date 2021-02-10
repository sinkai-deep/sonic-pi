
set :bpm, 115


live_loop :metro do
  use_bpm get[:bpm]
  sleep 4
end

set_mixer_control! hpf: 0, hpf_slide: 2
set_mixer_control! lpf: 140, lpf_slide: 4
set_mixer_control! amp: 1, amp_slide: 16

set :chord_progression, [:b2]

with_fx :reverb, room: 0.7 do
  live_loop :bass_2, sync: :metro do
    with_fx :eq, amp: 0.5, amp_slide: 64 do
      use_bpm get[:bpm]
      cp = get[:chord_progression].tick(:cp)
      n1 = [1,0,4,7, 2,4,0,1, 1,0,0,1, 5,4,0,2].tick(:note)
      n2 = [7,0,4,7, 2,4,0,1, 5,2,0,1, 5,4,0,7].shuffle.tick(:note2)
      notes = scale(cp, :minor)[n1]
      notes_2 = scale(cp, :minor)[n2]
      m = choose([24, 36])
      ##| notes = scale(cp, :minor).shuffle.tick(:note）
      
      with_fx :compressor, amp: 1.5 do
        with_fx :hpf, cutoff: 0, cutoff_slide: 32 do
          synth :tb303,
            note: notes,
            release: 0.15,
            amp: choose([0, 0.5]),
            ##| amp: 0,
            res: (range 0, 0.9, step: 0.05).mirror.tick(:res),
            ##| res: 0.9,
            cutoff: (range 60, 130, stsep: 0.05).mirror.tick(:cutoff),
            pan: (range -1, 1, step: 0.01).mirror.tick(:pan),
            wave: 1
          
          synth :tb303,
            note: notes_2 + m,
            release: 0.1,
            amp: choose([0, 1]),
            ##| amp: 0,
            res: (range 0, 0.9, step: 0.05).mirror.tick(:res),
            ##| res: 0.9,
            cutoff: (range 60, 130, stsep: 0.1).shuffle.tick(:cutoff),
            pan: (range -1, 1, step: 0.05).shuffle.tick(:pan),
            wave: 2
          
          
          if one_in(10)
            synth :fm,
              note: notes_2 + 36,
              attack: 0,
              release: 0.1,
              amp: 0.5,
              depth: (range 0, 1, step: 0.01).mirror.tick,
              ##| depth: 0,
              divisor: (range 0, 1, step: 0.01).mirror.tick
          end
          sleep 0.25
          ##| stop
        end
      end
    end
  end
end


with_fx :reverb, room: 0.8 do
  live_loop :ground, sync: :metro do
    with_fx :compressor, amp: 0.5 do
      with_fx :distortion, distort: 0.5 do
        use_bpm get[:bpm]
        ##| stop
        cp = get[:chord_progression].tick(:cp)
        n = [0,0,0,0, 0,0,0,1, 0,0,0,0, 0,0,0,1].tick(:n)
        notes = scale(cp, :minor)[n]
        
        synth :tb303,
          wave: 0,
          note: notes - 12,
          res: (range 0, 0.5, step: 0.01).mirror.tick(:res),
          cutoff: 90,
          amp: choose([0.5, 0.5]),
          release: 0.25
        sleep 0.25
      end
    end
  end
end

with_fx :reverb, room: 1 do
  live_loop :chords, sync: :metro do
    
    stop
    
    use_bpm get[:bpm]
    cp = get[:chord_progression].tick
    notes = chord(cp, :m)
    notes_2 = chord(:a3, :m7)
    
    sleep 0.5
    synth :fm,
      amp: 0.5,
      note: notes_2 + 12,
      depth: 0,
      release: 0.5
    sleep 0.5
    
    synth :fm,
      amp: 0.6,
      note: notes + 24,
      depth: 1,
      release: 0.7
    sleep 7
  end
end

with_fx :reverb, room: 1 do
  live_loop :chords_2, sync: :metro do
    use_bpm get[:bpm]
    cp = get[:chord_progression].tick
    notes = chord(cp, :m, chord_degree: 7)
    
    sleep 1
    synth :beep,
      amp: 0.4,
      note: notes + 24,
      depth: 0,
      release: 2
    sleep 3
    stop
  end
end


live_loop :drum, sync: :metro do
  with_fx :lpf, cutoff: 90 do
    use_bpm get[:bpm]
    num = rrand_i(64, 128)
    
    n_rand_1 = rrand_i(0, 4)
    ##| with_fx :ixi_techno, phase: choose([0.125, 0.5]) do
    sample :bd_ada, cutoff: 130, amp: 2 if spread(1,4).tick
    sample :elec_filt_snare,amp: 2, sustain: 0.05, cutoff: 90 if spread(1,4).rotate(2).look
    sample :elec_cymbal, amp: 1, sustain: 0.02 if spread(4,4).rotate(2).look
    sample :elec_snare, rate: 2, sustain: 0.025, release: 0.025,
      amp: 0.7 if spread(32,128).rotate(n_rand_1).tick(:t1)
    sleep 0.25
  end
  ##| stop
end






