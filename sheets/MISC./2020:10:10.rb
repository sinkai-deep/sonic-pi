
set :bpm, 135


live_loop :metro do
  use_bpm get[:bpm]
  sleep 4
end

set_mixer_control! hpf: 0, hpf_slide: 0
set_mixer_control! amp: 1, amp_slide: 16

set :chord_progression, [:b2, :e3]

with_fx :reverb, room: 0.4 do
  
  live_loop :tb, sync: :metro do
    with_fx :reverb, room: 1 do
      ##| stop
      use_bpm get[:bpm]
      cp = get[:chord_progression].tick(:cp)
      64.times do
        n1 = [0,2,4,7, 0,7,3,0, 4,0,3,2, 7,0,7,0].shuffle.tick(:note)
        notes = scale(cp, :minor)[n1]
        ##| notes = scale(cp, :minor).shuffle.tick(:note)
        
        with_fx :compressor, amp: 1 do
          if one_in(1)
            synth :tb303,
              note: notes + 48,
              release: 0.1,
              amp: rrand(0, 0.5),
              res: (range 0, 0.9, step: 0.25).mirror.tick(:res),
              cutoff: (range 60, 130, step: 10).mirror.tick(:cutoff)
          else
            sleep 0.25
          end
          sleep 0.25
        end
      end
    end
  end
  
  live_loop :tb_2, sync: :metro do
    ##| with_fx :echo, phase: 0.125 do
    stop
    use_bpm get[:bpm]
    cp = get[:chord_progression].tick(:cp)
    64.times do
      n1 = [0,2,4,7, 0,7,3,0, 4,0,3,2, 7,0,7,0].tick(:note)
      notes = scale(cp, :minor)[0]
      ##| notes = scale(cp, :minor).shuffle.tick(:note)
      
      with_fx :compressor, amp: 1 do
        with_fx :hpf, cutoff: 10, cutoff_slide: 2 do
          if one_in(1)
            synth :tb303,
              note: notes - 12,
              release: 0.1,
              amp: 1,
              res: (range 0, 0.9, step: 1).mirror.tick(:res),
              cutoff: (range 60, 130, step: 20).mirror.tick(:cutoff),
              pan: (range -1, 1, step: 0.25).mirror.tick(:pan)
          else
            sleep 0.25
          end
          sleep 0.25
        end
      end
    end
  end
  ##| end
  
  with_fx :reverb, room: 0.5 do
    live_loop :bass_fm, sync: :metro do
      ##| with_fx :echo, phase: 0.125 do
      stop
      use_bpm get[:bpm]
      cp = get[:chord_progression].tick(:cp)
      64.times do
        n1 = [0,2,4,3, 7,0,2,0, 2,2,0,2, 0,7,2,0].shuffle.tick(:note)
        notes = scale(cp, :minor)[n1]
        ##| notes = scale(cp, :minor).shuffle.tick(:note)
        
        with_fx :compressor, amp: 1 do
          if one_in(1)
            synth :tb303,
              note: notes - 12,
              release: 0.25,
              amp: choose([1, 1]),
              res: (range 0, 0.9, step: 0.05).mirror.tick(:res),
              ##| res: 0.5,
              cutoff: (range 60, 130, step: 10).mirror.tick(:cutoff),
              pan: (range -1, 1, step: 0.25).mirror.tick(:pan)
            
          else
            sleep 0.25
          end
          sleep 0.25
        end
      end
    end
  end
  
  
  with_fx :reverb, room: 1 do
    live_loop :ambi, sync: :metro do
      stop
      use_bpm get[:bpm]
      cp = [:b2, :e3].tick
      1.times do
        notes = chord(cp, :m, num_octaves: 3, chord_invert: 2)
        ##| a = range(0.1, 1, step: 0.1).mirror.tick(:amp)
        phase_ixi = rrand(0.5 ,2)
        with_fx :compressor, amp: 1 do
          with_fx :lpf, cutoff: 90 do
            with_fx :distortion, distort: 0.1 do
              synth :fm,
                note: notes - 24,
                amp: 1, amp_slide: 4,
                attack: 0.25,
                depth: 0,
                divisor: 1,
                release: 16,
                cutoff: 120
            end
          end
          sleep 16
        end
      end
    end
  end
  
  
  live_loop :drum, sync: :metro do
    use_bpm get[:bpm]
    ##| stop
    num = rrand_i(25, 48)
    with_fx :lpf, cutoff: 100 do
      n_rand_1 = rrand_i(0, 4)
      
      sample :bd_tek, rate: 0.8, cutoff: 90, amp: 0.9 if spread(1,4).tick
      sample :elec_filt_snare, rate: 1.5, sustain: 0.025, release: 0.125, amp: 1.8, cutoff: 100 if spread(1,4).rotate(2).look
      
      sample :elec_cymbal, rate: 1.5, sustain: 0.025, release: 0.125, amp: 1.5, cutoff: 100 if spread(32,128).rotate(4).tick(:t1)
      sleep 0.25
    end
  end
  
end



