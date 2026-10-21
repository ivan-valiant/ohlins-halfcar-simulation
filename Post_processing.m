% Extract time vector and data
time = ScopeData.time;
signal_names = {'Heave (z)', 'Heave Velocity (z_dot)', 'Pitch (theta)', 'Pitch Velocity (theta_dot)'};

disp('=====================================================================');
disp('      COMPREHENSIVE SEMI-ACTIVE VS. PASSIVE PERFORMANCE SUMMARY      ');
disp('=====================================================================');

for i = 1:4
    passive_signal = ScopeData.signals(i).values(:, 1);
    semi_signal    = ScopeData.signals(i).values(:, 2);
    
    % 1. Peak Metrics
    max_passive = max(abs(passive_signal));
    max_semi    = max(abs(semi_signal));
    peak_red_pct = ((max_passive - max_semi) / max_passive) * 100;
    
    % 2. RMS Metrics (Total transient energy / ride comfort)
    rms_passive = rms(passive_signal);
    rms_semi    = rms(semi_signal);
    rms_red_pct = ((rms_passive - rms_semi) / rms_passive) * 100;
    
    % % 3. Settling Time Calculation (5% tolerance band around final steady-state)
    % % Assuming final value at end of sim represents steady-state braking state
    % final_val_pass = passive_signal(end);
    % final_val_semi = semi_signal(end);
    
    % tolerance_pass = 0.05 * abs(max_passive - final_val_pass);
    % tolerance_semi = 0.05 * abs(max_semi - final_val_semi);
    % 
    % % Find last time index outside the tolerance band
    % idx_pass = find(abs(passive_signal - final_val_pass) > tolerance_pass, 1, 'last');
    % idx_semi = find(abs(semi_signal - final_val_semi) > tolerance_semi, 1, 'last');
    % 
    % if isempty(idx_pass), t_settle_pass = 0; else, t_settle_pass = time(idx_pass); end
    % if isempty(idx_semi), t_settle_semi = 0; else, t_settle_semi = time(idx_semi); end
    
    % Print formatted results
    fprintf('\n--------------------------------------------------\n');
    fprintf('Signal: %s\n', signal_names{i});
    fprintf('--------------------------------------------------\n');
    fprintf('  Peak Passive:     %.5f  | Peak Semi:     %.5f  (Red: %.2f%%)\n', max_passive, max_semi, peak_red_pct);
    fprintf('  RMS Passive:      %.5f  | RMS Semi:      %.5f  (Red: %.2f%%)\n', rms_passive, rms_semi, rms_red_pct);
    % fprintf('  Settling Time (5%): Pass = %.2fs  | Semi = %.2fs\n', t_settle_pass, t_settle_semi);
end
disp('==================================================================');