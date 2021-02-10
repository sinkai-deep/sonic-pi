bpm = 125

live_loop :metro do
  use_bpm bpm
  sleep 4
end

set_mixer_control! hpf: 0, hpf_slide: 4
set_mixer_control! lpf: 130, lpf_slide: 2
set_mixer_control! amp: 1, amp_slide: 2

with_fx :reverb, room: 0.8 do
  live_loop :ground, sync: :metro do
    
    tick
    use_random_seed [1999, 2000, 2049, 2077, 1984].choose
    use_bpm bpm
    
    ##| stop
    num_n2 = [0,12].choose
    32.times do
      cp = ['e3'].look
      puts cp
      sc = ['minor'].look
      
      
      n = [7, 6, 3, 4].look
      n2 = [0, 1, 2, 5, 7].shuffle.look
      
      notes = scale(cp, sc).shuffle.tick(:notes)
      notes2 = scale(cp, sc).shuffle.tick(:notes2)
      notes3 = scale(cp, sc)[n]
      notes4 = scale(cp, sc)[n2]
      
      num = rrand_i(1, 64)
      num2 = rrand_i(1,64)
      num3 = rrand_i(1,64)
      
      if one_in(0)
        with_fx :distortion, amp: 1, distort: 0.1 do
          with_fx :eq, high: 0.2 do
            if spread(num,num2).rotate(num3).tick(:fm1)
              synth :sine,
                note: notes + 12,
                depth: 0,
                divisor: 0,
                attack: 0.05,
                amp: 0.8,
                release: [0.25, 0.5].choose
            end
          end
        end
      end
      
      with_fx :lpf, cutoff: 90 do
        if spread(16, 16).rotate(num3).tick(:b1)
          synth :tb303,
            note: notes3 - 12,
            ##| res: 0,
            ##| wave: 0,
            ##| depth: 0,
            ##| divisor: 0,
            res: (range 0, 0.9, 0.01).mirror.look(:b1),
            cutoff: (range 50, 130, 1).mirror.look(:b1),
            attack: 0.01,
            amp: 1,
            release: 0.25
        end
      end
      
      sleep 0.25
    end
    # stop
  end
end




with_fx :reverb, room: 1, mix: 0.5 do
  live_loop :chords, sync: :metro do
    stop
    use_bpm bpm
    tick
    
    cp = ['e3', 'b3', 'a3', 'e3'].look
    tone = ['m','m', 'm7', 'm'].look
    sc = get[:sc]
    
    notes = chord(cp, tone, num_octaves: 3, chord_invert: 0)
    n = 8
    ##| if one_in(1)
    with_fx :lpf, cutoff: 120 do
      with_fx :slicer, phase: [0.75].choose do
        ##| with_fx :ixi_techno, phase: 16 do
        synth :sine,
          amp: 1.5,
          depth: 1,
          attack: n/16,
          note: notes - 12,
          release: n,
          sustain: n*0.9
        ##| end
      end
    end
    sleep n
    ##| stop
  end
end

with_fx :reverb, room: 0.3 do
  live_loop :bd, sync: :metro do
    
    ##| stop
    use_bpm bpm
    tick
    with_fx :bpf, centre: 50, res: 0.4 do
      with_fx :eq, amp: 1, low: 0.5, mid: 0.8, high: 0 do
        sample :bd_tek, amp: 1, rate: 1, attack: 0.01 if spread(1,4).look
      end
    end
    
    ##| stop
    sleep 0.25
  end
end

with_fx :reverb, room: 0.1 do
  live_loop :pc, sync: :metro do
    ##| stop
    use_bpm bpm
    tick
    ##| num = dice(8)
    
    with_fx :lpf, cutoff: 100 do
      with_fx :bpf, centre: 100, res: 0.5 do
        with_fx :eq, amp: 1,low: 0, high: 0.2, mid: 0.3 do
          sample :drum_cymbal_pedal, amp: 1.5,  release: 0.1 if spread(4,16).rotate(2).look
          sample :drum_cymbal_closed, amp: 1 if spread(1 ,8).rotate(2).look
        end
      end
    end
    
    if one_in(1)
      with_fx :bpf, centre: 90, res: 0.3 do
        with_fx :eq, low: 1, mid: 0.2, amp: 2 do
          n = [1, 2, 3, 4].choose
          sample :drum_tom_mid_soft if spread(n, 32).rotate(0).look
          sample :drum_tom_mid_soft if spread(n,32).rotate(1).look
          sample :drum_tom_hi_soft if spread(n,32).rotate(2).look
        end
      end
    end
    
    sleep 0.25
  end
end








