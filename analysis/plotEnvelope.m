function plotEnvelope(env,label1,env2,label2)
    %   plotEnvelope    Plots the passed envelope(s)
    %       plotEnvelope(envelope,label) plots one
    %       plotEnvelope(envelope,label,envelope2,label2) plots two envelopes
    %
    %       See also envelopeGenerator.m
    
    figure('Position', [100, 100, 800, 800])
    red = [0.698 0.0941 0.1686];
    blue = [0.1294 0.4 0.67451];

    plot(env,'Color',blue,'LineWidth',2)
    if nargin > 2
        hold on
        plot(env2,'Color',red,'LineWidth',2)
        lgnd = legend(label1,label2,'Location','northeast');
    else
        lgnd = legend(label1,'Location','northeast');
    end
    set(gca,'FontSize',25)
    ylabel('Amplitude', 'Rotation', 90, 'FontSize', 30);
    xlabel('Time','FontSize', 30);
end
