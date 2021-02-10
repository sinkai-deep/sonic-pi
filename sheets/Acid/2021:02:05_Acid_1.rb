
set :bpm, 126

live_loop :metro do
  use_bpm get[:bpm]
  sleep 4
end

live_loop :control, sync: :metro do
  cp = ['b4', 'e4'].tick(:cp)
  tone = ['m9', 'm7'].tick(:tn)
  sc = 'minor_pentatnonic'
  set :cp, cp
  set :tone, tone
  set :sc, sc
  sleep 8
end

set_mixer_control! hpf: 0, hpf_slide: 1
set_mixer_control! lpf: 130, lpf_slide: 2
set_mixer_control! amp: 1, amp_slide: 2

with_fx :reverb, room: 0.8 do
  live_loop :ground, sync: :metro do
    4.times do
      
      # use_random_seed 1985
      use_bpm get[:bpm]
      
      ##| stop
      
      cp = get[:cp]
      sc = get[:sc]
      
      n = [0,0,0,1].look(:n2)
      n2 = [5,0,0,7, 3,0,0,1, 0,5,0,1, 0,0,0,1].tick(:n2)
      
      notes = scale(cp, sc).shuffle.tick(:notes)
      notes2 = scale(cp, sc).shuffle.tick(:notes2)
      notes3 = scale(cp, sc)[n]
      notes4 = scale(cp, sc)[n2]
      
      num = rrand_i(0, 64)
      num2 = rrand_i(0,64)
      
      with_fx :distortion, amp: 0.5, distort: 0.1 do
        with_fx :eq, high: 1.5, high_shelf: 0 do
          if spread(16,16).rotate(num2).tick(:fm1)
            synth :fm,
              note: notes,
              attack: 0.03,
              depth: 0,
              divisor: 0,
              amp: 1, amp_slide: 16,
              release: rand if rand > 0.5
          end
        end
      end
      
      # if spread(25, 32).rotate(num).tick(:tb1)
      #    synth :tb303,
      #      note: notes4 -12,
      #      res: 0.9,
      #      res: (range 0, 0.9, 0.05).mirror.look(:tb1),
      #      cutoff: (range 60, 160, 1).mirror.look(:tb1),
      #      wave: 0,
      #      amp: 0.5, amp_slide: 16,
      #      release: 0.25,
      #      susatain: 0.25
      #  end
      
      sleep 0.25
      # stop
    end
  end
end



with_fx :reverb, room: 1 do
  live_loop :chords, sync: :control do
    # stop
    use_bpm get[:bpm]
    
    cp = get[:cp]
    tone = get[:tone]
    
    notes = chord(cp, tone)
    
    with_fx :distortion, distort: 0.6 do
      with_fx :slicer, phase: [0.25, 0.5, 0.75].choose do
        synth :sine,
          amp: 0.1,
          res: 0.4,
          note: notes - 12,
          release: 16
      end
    end
    
    # if one_in(1)
    #   with_fx :eq, high: 1 do
    #     sample :vinyl_backspin, amp: 1,amp_slide: 16, rate: -0.6, sustain: 16
    #   end
    # end
    
    sleep 8
  end
end

with_fx :reverb, room: 1 do
  live_loop :bass, sync: :control do
  # stop
  use_bpm get[:bpm]
  cp = get[:cp]
  tone = get[:tone]

    notes = chord(cp, tone)
    with_fx :eq, low: 0.5, amp: 0.3 do
      with_fx :slicer, phase: 0.75 do
        with_fx :ixi_techno, phase: dice(16), mix: 0.2 do
          synth :fm,
            note: notes - 12,
            amp: 0.4,
            cutoff: 120,
            release: 16
          end
        end
      end
    sleep 8
  end
end


with_fx :reverb, room: 0.3 do
  live_loop :bd, sync: :metro do
    
    # stop
    use_bpm get[:bpm]
    
    
    with_fx :bpf, centre: 50 do
      with_fx :eq, amp: 2, low_shelf: -0.2, low: -0.8, mid: -0.6, high: 0.5 do
        sample :bd_haus, amp: 1, rate: 1 if spread(1,4).tick
        # sample :bd_haus,amp: 4, sustain: 0.25, rate: 0.7,cutoff: 90 if spread(1,8).rotate(5).look
      end
    end
    ##| stop
    sleep 0.25
  end
end

with_fx :reverb, room: 0.1 do
  live_loop :pc, sync: :metro do
    # stop
    use_bpm get[:bpm]
    tick
    with_fx :eq, amp: 1,low: -2, high: -0.2 do
      sample :drum_cymbal_soft,amp: 0.5, sustain: 0.1, release: 0.1 if spread(1,4).rotate(2).look
      sample :drum_cymbal_closed,amp: 0.4,sustain: 0.1, release: 0.2 if spread(16,16).rotate(2).look
    end
    
    # with_fx :eq, amp: 1 do
    #   with_fx :bpf, centre: 90 do
    #     sample :drum_cymbal_hard,amp: 1, sustain: 0.25, release: 0.25 if spread(1,4).look
    #   end
    # end

    sleep 0.25
  end
end







