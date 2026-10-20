% Extract time vector
time = ScopeData.time;

% Define your signal names for clean output printing
signal_names = {'Bounce (z)', 'Bounce Velocity (z_dot)', 'Pitch (theta)', 'Pitch Velocity (theta_dot)'};

disp('===================================================');
disp('    SEMI-ACTIVE VS. PASSIVE PERFORMANCE SUMMARY    ');
disp('===================================================');

for i = 1:4
    % Column 1: Passive, Column 2: Semi-Active
    passive_signal = ScopeData.signals(i).values(:, 1);
    semi_signal    = ScopeData.signals(i).values(:, 2);
    
    % Calculate peak absolute values (maximum dive/oscillation)
    max_passive = max(abs(passive_signal));
    max_semi    = max(abs(semi_signal));
    
    % Calculate percentage reduction
    reduction_pct = ((max_passive - max_semi) / max_passive) * 100;
    
    % Print results
    fprintf('\nSignal: %s\n', signal_names{i});
    fprintf('  Peak Passive:     %.5f\n', max_passive);
    fprintf('  Peak Semi-Active: %.5f\n', max_semi);
    fprintf('  Peak Reduction:   %.2f%%\n', reduction_pct);
end
disp('==================================================');