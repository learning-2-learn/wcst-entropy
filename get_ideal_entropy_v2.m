
function [ideal_entropy] = get_ideal_entropy_v2(trial_presentations)

%trial_presentations contains the combination of cards presented on each
%trial

%this variables is extracted from the task behavioral output file

total_rule_list = {'S1'; 'T1'; 'C1'; 'Q1'; 'B2'; 'Y2'; 'G2'; 'M2'; 'L3'; 'P3'; 'S3'; 'R3'};
%dim1 = shape, dim2 = color, dim3 = texture;


curr_prob = 1 / numel(total_rule_list);
curr_prob_distr(1:numel(total_rule_list)) = curr_prob;

start_entropy = -sum(curr_prob_distr.*(log2(curr_prob_distr))); %calculates Shannon entropy based on initial conditions
%initial conditions means the probability distribution containing 12
%equally probable rules

ideal_entropy = zeros(1, size(trial_presentations, 1));

if exist('curr_buffer') == 1

    clear curr_buffer;

end

for i = 1:1


    for ii = 1:4

        curr_trial = trial_presentations{i, ii}(1:3);

        for j = 1:numel(curr_trial)

            curr_trial_all(ii).bmp{j} = sprintf('%s%d', curr_trial(j), j);

        end

    end

    %%
    %on the first trial, choice is random, as all the choices reduce the
    %uncertainty equally
    r = randi([1, 4], 1, 1);

    curr_chosen_rule = curr_trial_all(r).bmp;

    for x = 1:numel(curr_chosen_rule)

        curr_buffer(x, :) = curr_chosen_rule{x};


    end


end

items_left = numel(total_rule_list) - size(curr_buffer, 1); %adjust the number of remaining rules by subtracting the 3 rules tested on the first trial

curr_prob = 1 / items_left;
curr_prob_distr = [];
curr_prob_distr(1:items_left) = curr_prob; %calculates the probability distribution after the 1st trial

ideal_entropy(i) = start_entropy;

%%
%
for i = 2:size(trial_presentations, 1) %calculates the overlap between the buffer and each of the 4 cards presented on i-th trial

    if min(ideal_entropy) >= 0

        for ii = 1:4

            curr_trial = trial_presentations{i, ii}(1:3);

            for j = 1:numel(curr_trial)

                curr_trial_all(ii).bmp{j} = sprintf('%s%d', curr_trial(j), j);

            end


            for xx = 1:numel(curr_trial_all)

                curr_rule = curr_trial_all(xx).bmp';

                overlap(xx) = 0;

                for xxx = 1:numel(curr_rule)

                    curr_subrule = curr_rule{xxx};


                    for y = 1:size(curr_buffer, 1)


                        if strcmp(curr_buffer(y, :), curr_subrule) == 1

                            overlap(xx) = overlap(xx) + 1;

                        end


                    end

                end

            end

        end


        min_overlap = find(overlap == min(overlap)); %as this function computes the entropy based on the ideal observer, this line
        %finds the card with the MINIMAL overlap w buffer, which is selected as
        %an ideal observer choice on this trial. choosing the card with minimal
        %overlap w buffer allows for the most efficient search through remaining
        %rules


        if numel(min_overlap) > 1 %if more than one card contains minimal overlap, the chosen card on i-th trial is selected randomly
            %between the set of cards with minimal overlap

            r = randi([1, numel(min_overlap)], 1, 1);

            min_overlap = min_overlap(r);

            curr_chosen_card = curr_trial_all(min_overlap).bmp;

        elseif numel(min_overlap) == 1


            curr_chosen_card = curr_trial_all(min_overlap).bmp;

        end

        %%
        %loops through the 3 rules tested on i-th trial and checks if a given
        %rule is not already in the buffer, it gets added

        for iii = 1:numel(curr_chosen_card)


            curr_subfeature = curr_chosen_card{iii};


            new_item = 0;

            for ix = 1:size(curr_buffer, 1)


                if strcmp(curr_buffer(ix, :), curr_subfeature) == 1

                    new_item = new_item + 1;

                end


            end


            if new_item == 0

                curr_buffer(size(curr_buffer, 1)+1, :) = curr_subfeature;

            end


        end


        items_left = numel(total_rule_list) - size(curr_buffer, 1); %calculates the number of remaining rules


        curr_prob = 1 / items_left;
        curr_prob_distr = [];
        curr_prob_distr(1:items_left) = curr_prob; %creates the probability distribution of remaining rules

        ideal_entropy(i) = -sum(curr_prob_distr.*(log2(curr_prob_distr))); %calculates the Shannon entropy on i-th trial

    end

end

