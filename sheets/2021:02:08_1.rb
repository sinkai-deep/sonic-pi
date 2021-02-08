
bpm = 128

live_loop :metro do
  use_bpm bpm
  sleep 4
end

live_loop :control, sync: :metro do
  ##| stop
  use_bpm bpm
  tick
  cp = ['e3'].look
  tone = ['m'].look
  sc = 'iwato'
  set :cp, cp
  set :tone, tone
  set :sc, sc
  sleep 16
end

set_mixer_control! hpf: 0, hpf_slide: 1
set_mixer_control! lpf: 130, lpf_slide: 2
set_mixer_control! amp: 1, amp_slide: 2

with_fx :reverb, room: 0.8 do
  live_loop :ground, sync: :metro do
    
    use_random_seed dice(99999)
    use_bpm bpm
    
    stop
    
    cp = get[:cp]
    sc = get[:sc]
    n = [0,0,0,1].look(:n2)
    n2 = [5,0,0,7, 3,0,0,1, 0,5,0,1, 0,0,0,1].tick(:n2)
    
    notes = scale(cp, sc).shuffle.tick(:notes)
    notes2 = scale(cp, sc).shuffle.tick(:notes2)
    notes3 = scale(cp, sc)[n]
    notes4 = scale(cp, sc)[n2]
    
    num = rrand_i(1, 8)
    num2 = rrand_i(1,64)
    num3 = rrand_i(1,64)
    
    with_fx :distortion, amp: 0.5, distort: 0 do
      with_fx :eq, high: 0 do
        if spread(16,num2).rotate(num3).tick(:fm1)
          synth :fm,
            note: notes + 12,
            attack: 0.02,
            depth: 0,
            amp: 0.3, amp_slide: 16,
            release: rand if (rand<1)
        end
      end
    end
    
    if spread(12, 16).rotate(num).tick(:tb1)
      synth :tb303,
        note: notes4 -12,
        res: (range 0, 0.9, 0.05).mirror.look(:tb1),
        cutoff: (range 60, 130, 1).mirror.look(:tb1),
        wave: 0,
        amp: 0.2, amp_slide: 16,
        release: 0.25,
        susatain: 0.25
    end
    
    sleep 0.25
    # stop
  end
end




with_fx :reverb, room: 1 do
  live_loop :chords, sync: :metro do
    stop
    use_bpm bpm
    tick
    
    cp = get[:cp]
    tone = get[:tone]
    
    notes = chord(cp, tone)[0]
    
    n = [0.5, 1, 2].choose
    
    with_fx :distortion, distort: 0.01 do
      with_fx :slicer, phase: [0.25, 0.5, 0.75].choose do
        synth :fm,
          amp: 0.4,
          depth: 0,
          note: notes + [0, 12].choose,
          release: n
      end
    end
    
    sleep n
  end
end

with_fx :reverb, room: 1 do
  live_loop :bass, sync: :metro do
    ##| stop
    use_bpm bpm
    cp = get[:cp]
    tone = get[:tone]
    
    notes = chord(cp, tone)
    with_fx :eq, low: 0.5, amp: 0.3 do
      with_fx :slicer, phase: [0.5, 0.75].choose do
        with_fx :ixi_techno, phase: dice(16), mix: 0.4 do
          synth :sine,
            note: notes + 12,
            depth: 0,
            amp: 0.5,
            cutoff: 120,
            release: 16
        end
      end
    end
    sleep 16
  end
end


with_fx :reverb, room: 0.3 do
  live_loop :bd, sync: :control do
    
    ##| stop
    use_bpm bpm
    
    
    with_fx :bpf, centre: 50, res: 0.3 do
      with_fx :eq, amp: 3, low_shelf: -0.2, low: -0.8, mid: -0.6, high: -1 do
        sample :bd_haus, amp: 2, rate: 1 if spread(1,4).tick
        ##| sample :bd_haus,amp: 4, sustain: 0.25, rate: 0.7,cutoff: 90 if spread(1,8).rotate(5).look
      end
    end
    ##| stop
    sleep 0.25
  end
end

with_fx :reverb, room: 0.1 do
  live_loop :pc, sync: :control do
    ##| stop
    use_bpm bpm
    tick
    with_fx :bpf, centre: 120, res: 0.2 do
      with_fx :eq, amp: 1,low: -2, high: -0.2 do
        sample :drum_cymbal_pedal, amp: 0.5, sustain: 0.1, release: 0.1 if spread(1,4).rotate(2).look
        sample :tabla_re, amp: 1,sustain: 0.1, release: 0.2 if spread(1,4).rotate(2).look
      end
      
      
      ##| with_fx :eq, amp: 1 do
      ##|   with_fx :bpf, centre: 90 do
      ##|     sample :drum_cymbal_soft,amp: 1, sustain: 0.25, release: 0.25 if spread(1,16).rotate(4).look
      ##|   end
      ##| end
    end
    
    sleep 0.25
  end
end







