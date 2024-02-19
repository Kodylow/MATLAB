function stateMatrix = exec(n, rule)
    
    % Initialize the ECA with the given rule and number of steps
    eca = ECA(rule, n);

    % Run the evolution
    stateMatrix = eca.runEvolution();
    
    %  Visualization
    bw = gray(2);
    colormap(bw(end:-1:1, :));
    imagesc(stateMatrix);
    axis square off equal;
    
end

