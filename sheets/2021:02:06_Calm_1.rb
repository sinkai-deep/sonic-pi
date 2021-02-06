
set :bpm, 126

live_loop :metro do
  use_bpm get[:bpm]
  sleep 4
end

live_loop :control, sync: :metro do
  cp = ['b4', 'e4'].tick(:cp)
  tone = ['m9', 'm7'].tick(:tn)
  sc = 'minor_pentatonic'
  set :cp, cp
  set :tone, tone
  set :sc, sc
  sleep 8
end

set_mixer_control! hpf: 0, hpf_slide: 1
set_mixer_control! lpf: 60, lpf_slide: 8
set_mixer_control! amp: 0, amp_slide: 4

with_fx :reverb, room: 0.8 do
  live_loop :ground, sync: :metro do
    4.times do
      
      # use_random_seed 1985
      use_bpm get[:bpm]
      
      stop
      
      cp = get[:cp]
      sc = get[:sc]
      
      n = [0,0,0,1].look(:n2)
      n2 = [5,0,0,7, 3,0,0,1, 0,5,0,1, 0,0,0,1].tick(:n2)
      
      notes = scale(cp, sc).shuffle.tick(:notes)
      notes2 = scale(cp, sc).shuffle.tick(:notes2)
      notes3 = scale(cp, sc)[n]
      notes4 = scale(cp, sc)[n2]
      
      num = rrand_i(0, 64)
      num2 = rrand(0.25 , 1.5)
      
      with_fx :compressor, amp: 1  do
        ##| with_fx :ixi_techno, phase: num2%8, cutoff_max: 90 do
        with_fx :eq, high: -2, high_shelf: 0 do
          if spread(3,16).rotate(num2).tick(:fm1)
            synth :sine,
              attack: 0.05,
              note: notes - [0,12].choose,
              amp: 0.6,
              release: 0.25
          end
        end
        
        if spread(13, 16).rotate(num).look(:fm1) do
            synth :sine,
              note: notes2 -12,
              amp: 0.6,
              release: 0.25
          end
        end
        
        
        sleep 0.25
      end
      stop
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
          pan: (range -1, 1, 0.1).mirror.look,
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
    stop
    use_bpm get[:bpm]
    cp = get[:cp]
    tone = get[:tone]
    
    notes = chord(cp, tone)[0,1].choose
    with_fx :eq, low: 0.5, amp: 0.3 do
      with_fx :slicer, phase: [0.25,0.5,0.75].choose do
        with_fx :ixi_techno, phase: dice(16), mix: 0.5 do
          synth :fm,
            note: notes - 12,
            amp: 0.4,
            cutoff: 120,
            pan: (range -1, 1, 0.05).mirror.look,
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
    stop
    use_bpm get[:bpm]
    tick
    with_fx :eq, amp: 0.5,low: -2, high: -0.2 do
      sample :drum_cymbal_soft,amp: 0.5, sustain: 0.1, release: 0.1 if spread(1,4).rotate(2).look
      ##| sample :drum_cymbal_closed,amp: 0.4,sustain: 0.1, release: 0.2 if spread(16,16).rotate(2).look
    end
    
    with_fx :eq, amp: 0.4 do
      with_fx :bpf, centre: 90 do
        sample :drum_cymbal_soft,amp: 1, sustain: 0.25, release: 0.25 if spread(1,4).look
      end
    end
    
    sleep 0.25
  end
end







