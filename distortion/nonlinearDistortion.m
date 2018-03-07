function signal = nonlinearDistortion(signal,amount,env)
    %Applies nonlinear distortion using the passed envelope
    
    N = length(env.env);

    %Clip Input
    signal = min(signal,1.0);
    signal = max(signal,-1.0);

    %Transform to [0,1]
    dst = (signal + 1.0) / 2.0;
    dst = round(dst * N);

    %Apply Waveshaper Envelope
    dst = env.env(max(1,dst))';

    %Transform to [-1,1]
    dst = dst * 2.0;
    dst = dst - 1.0;

    if (size(dst,1) == size(signal,1))
        signal = amount * dst + (1-amount) * signal;
    else
        signal = amount * dst' + (1-amount) * signal;
    end
end
