
set :bpm, 127

##| live_loop :metro do
##|   use_bpm get[:bpm]
##|   sleep 4
##| end

live_loop :control do
  use_bpm get[:bpm]
  ##| stop
  tick
  cp = ['c4', 'g3'].look
  tone = ['m9','m'].look
  sc = 'minor_pentatonic'
  set :cp, cp
  set :tone, tone
  set :sc, sc
  sleep 16
end

set_mixer_control! hpf: 20, hpf_slide: 2
set_mixer_control! lpf: 160, lpf_slide: 2
set_mixer_control! amp: 1, amp_slide: 32

with_fx :reverb, room: 0.2 do
  live_loop :bass, sync: :control do
    tick
    
    use_random_seed dice(9999)
    
    use_bpm get[:bpm]
    
    ##| stop
    
    cp = get[:cp]
    sc = get[:sc]
    
    n2 = [5,0,0,7, 3,0,0,1, 0,5,0,1, 0,0,0,1].look
    
    notes = scale(cp, sc).shuffle.look
    notes2 = scale(cp, sc).shuffle.look
    notes3 = scale(cp, sc)[n2]
    
    num = rrand_i(0, 64)
    num2 = rrand_i(0,64)
    
    
    ##| with_fx :eq, high: 0, high_shelf: 0 do
    if spread(4,16).rotate(num2).look
      synth :kalimba,
        note: notes3 + 12 ,
        clickness: 1,
        amp: 3, amp_slide: 16,
        release: [0.25, 0.5, 0.75, 1].choose
    end
    ##| end
    sleep 0.5
    ##| stop
  end
end


with_fx :reverb, room: 0.2 do
  live_loop :bass_2, sync: :control do
    
    tick
    
    use_random_seed 2077
    
    use_bpm get[:bpm]
    
    ##| stop
    
    cp = get[:cp]
    sc = get[:sc]
    
    n2 = [5,0,0,7, 3,0,0,1, 0,5,0,1, 0,0,0,1].look
    
    notes = scale(cp, sc).shuffle.look
    notes2 = scale(cp, sc).shuffle.look
    notes3 = scale(cp, sc)[n2]
    
    num = rrand_i(0, 64)
    num2 = rrand_i(0,64)
    
    with_fx :eq, high: -0.5, low_shelf: 0.6, high_shelf: 0 do
      if spread(25, 32).rotate(num).look
        with_fx :lpf, cutoff: 60 do
          synth :tb303,
            note: notes3 - 12,
            res: (range 0, 0.9, 0.1).mirror.look,
            cutoff: (range 40, 120, 1).mirror.look,
            pan: (range -1, 1, 0.01).look,
            wave: 0,
            amp: 1, amp_slide: 16,
            release: 0.25
        end
      end
    end
    
    sleep 0.25
    ##| stop
  end
end

with_fx :reverb, room: 1 do
  live_loop :chord, sync: :control do
    
    ##| stop
    
    use_bpm get[:bpm]
    cp = get[:cp]
    tone = get[:tone]
    notes = chord(cp, tone, num_octarves: 3)
    
    with_fx :slicer, mix: 0.8, phase: [0.25,0.5,0.75].choose do
      synth :fm,
        amp: 1, amp_slide: 16,
        depth: 0,
        note: notes + 12,
        release: 16
    end
    
    sleep 16
  end
end


with_fx :reverb, room: 0.3 do
  live_loop :bd, sync: :control do
    ##| stop
    use_bpm get[:bpm]
    
    
    tick
    with_fx :lpf, cutoff: 70, cutoff_slide: 16 do
      with_fx :eq, amp: 5, low_shelf: -1, low: -0.8, mid: -0.6, high: 0.5 do
        ##| sample :bd_klub, amp: 4, rate: 1 if spread(2,4).look
        sample :bd_haus,amp: 3, sustain: 0.25, rate: 0.7,cutoff: 90 if spread(2,4).look
      end
    end
    
    ##| with_fx :eq, amp: 0.6,low: -2, high: -0.2 do
    ##|   sample :drum_cymbal_soft,amp: 1, sustain: 0.1, release: 0.2, cutoff: 100 if spread(12,16).rotate(1).look
    ##|   sample :drum_cymbal_closed,amp: 0.4,sustain: 0.1, release: 0.2 if spread(4,8).rotate(3).look
    ##| end
    
    sleep 0.5
  end
end







