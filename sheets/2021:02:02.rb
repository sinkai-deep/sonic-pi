
set :bpm, 120
cp = ('c3')
tone = ('m9')
sc = ('minor')
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
      n = [0,0,0,0, 0,0,0,7, 0,0,0,0, 0,0,0,1].tick(:n)
      notes = scale(cp, sc)[n]
      
      synth :fm,
        wave: 0,
        note: notes,
        res: (range 0, 0.9, step: 0.01).mirror.tick(:res),
        cutoff: (range 50, 120, step: 1).mirror.tick(:cf),
        amp: choose([0, 1]),
        release: 0.25
      sleep 0.25
    end
  end
end

with_fx :reverb, room: 1 do
  live_loop :chords, sync: :metro do
    
    ##| stop
    
    use_bpm get[:bpm]
    cp = get[:cp]
    tone = get[:tone]
    notes = chord(cp, tone)
    
    synth :fm,
      amp: 0.1,
      note: notes,
      depth: 0,
      sutain: 5
    sleep 8
  end
end

with_fx :reverb, room: 1 do
  live_loop :chords_2, sync: :metro do
    ##| stop
    use_bpm get[:bpm]
    
    cp = get[:cp]
    tone = get[:tone]
    
    notes = chord(cp, tone, chord_degree: 4)
    
    synth :fm,
      amp: 0.5,
      note: notes,
      depth: 0,
      release: 16,
      decay: 0
    sleep 16
    
  end
end


live_loop :drum, sync: :metro do
  with_fx :lpf, cutoff: 90 do
    ##| stop
    use_bpm get[:bpm]
    with_fx :lpf, cutoff: 90 do
      sample :bd_haus,amp: 1, sustain: 0.25, rate: 0.8 if spread(1,4).tick
    end
    sleep 0.25
  end
  ##| stop
end






