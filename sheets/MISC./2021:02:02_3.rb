
set :bpm, 120
cp = ('g2')
tone = ('M')
sc = ('major')
set :cp, cp
set :tone, tone
set :sc, sc

live_loop :metro do
  use_bpm get[:bpm]
  sleep 4
end

set_mixer_control! hpf: 0, hpf_slide: 2
set_mixer_control! lpf: 140, lpf_slide: 4
set_mixer_control! amp: 1, amp_slide: 1

with_fx :reverb, room: 0.8 do
  live_loop :ground, sync: :metro do
    with_fx :compressor, amp: 0.5 do
      
      
      use_bpm get[:bpm]
      ##| stop
      cp = get[:cp]
      sc = get[:sc]
      ##| n = [0,0,7,0,0,0,0,7].shuffle.tick(:n)
      ##| n2 = [0,0,7,1,5].shuffle.tick(:n2)
      notes = scale(cp, sc).shuffle.look
      notes2 = scale(cp, sc).shuffle.look
      num = rrand_i(0, 64)
      num2 = rrand_i(0,54)
      
      
      if spread(57,64).rotate(num).tick(:tb)
        synth :tb303,
          note: notes,
          wave: 0,
          res: (range 0, 0.9, step: 0.1).mirror.tick(:res),
          cutoff: (range 50, 120, step: 1).mirror.tick(:cf),
          amp: 0.2,
          release: 0.25
      end
      if spread(35,64).rotate(num2).tick(:fm)
        synth :fm,
          note: notes2,
          depth: 0,
          cutoff: (range 50, 120, step: 1).shuffle.tick(:cf2),
          amp: choose([1, 1]),
          release: 0.5
      end
      sleep 0.25
    end
  end
end


with_fx :reverb, room: 1 do
  live_loop :chords_2, sync: :metro do
    ##| stop
    use_bpm get[:bpm]
    
    cp = get[:cp]
    tone = get[:tone]
    
    notes = chord(cp, tone, num_octaves: 3)
    
    with_fx :ixi_techno, phase: dice(16) do
      synth :fm,
        amp: 0.2,
        note: notes,
        depth: 1,
        sustain: 1,
        release: 1
      sleep 8
    end
  end
end


with_fx :reverb, room: 0.6 do
  live_loop :drum, sync: :metro do
    with_fx :lpf, cutoff: 90 do
      ##| stop
      use_bpm get[:bpm]
      with_fx :lpf, cutoff: 60 do
        sample :bd_haus,amp: 1, sustain: 0.25, rate: 1 if spread(1,4).tick
      end
      with_fx :compressor, amp: 0.5 do
        ##| sample :drum_cymbal_soft,rate: 1,sustain: 0.15, release: 0.1, cutoff: 120 if spread(2,8).rotate(2).look
        ##| sample :drum_tom_lo_soft, amp: 1, sustain: 0.1, release: 0.1 if spread(10,32).rotate(1).look
      end
      
      
      sleep 0.25
    end
    ##| stop
  end
end






