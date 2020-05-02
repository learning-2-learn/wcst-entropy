
function [response_based_entropy] = get_response_based_entropy_v2(trial_presentations, responses)
%trial_presentations contains the combination of cards presented on each
%trial
%responses contains the list of arrow key responses on each trial
%both variables are extracted from the task behavioral output file

total_rule_list = {'S1'; 'T1'; 'C1'; 'Q1'; 'B2'; 'Y2'; 'G2'; 'M2'; 'L3'; 'P3'; 'S3'; 'R3'};

%dim1 = shape, dim2 = color, dim3 = texture;


curr_prob = 1 / numel(total_rule_list);
curr_prob_distr(1:numel(total_rule_list)) = curr_prob;

start_entropy = -sum(curr_prob_distr.*(log2(curr_prob_distr)));

response_based_entropy = zeros(1, size(trial_presentations, 1));


columns_arrow_keys = {'left'; 'down'; 'right'; 'up'};

for i = 1:size(trial_presentations, 1) %based on the arrow key chosen by the patient on i-th trial, this loop extracts the chosen card

    if min(response_based_entropy) >= 0

        curr_response = responses{i};

        if strcmp(curr_response, 'left') == 1

            curr_chosen_card = trial_presentations{i, 1}(1:3);

        elseif strcmp(curr_response, 'down') == 1

            curr_chosen_card = trial_presentations{i, 2}(1:3);

        elseif strcmp(curr_response, 'right') == 1

            curr_chosen_card = trial_presentations{i, 3}(1:3);

        elseif strcmp(curr_response, 'up') == 1

            curr_chosen_card = trial_presentations{i, 4}(1:3);

        end


        if i == 1 %on the first trial (if i == 1), all 3 rules from selected card are moved to the buffer

            for z = 1:numel(curr_chosen_card)


                curr_buffer{z} = sprintf('%s%d', curr_chosen_card(z), z);

            end


        else %else the for each of the 3 remaining rules, this loop checks if it's already in the buffer. if not, it gets added.

            for iii = 1:numel(curr_chosen_card)


                subfeature{iii} = sprintf('%s%d', curr_chosen_card(iii), iii);

            end

            overlap = sum(ismember(subfeature, curr_buffer));

            for iii = 1:numel(subfeature)

                curr_subfeature = subfeature{iii};

                new_item = 0;

                for ix = 1:numel(curr_buffer)


                    if strcmp(curr_buffer{ix}, curr_subfeature) == 1

                        new_item = new_item + 1;

                    end


                end


                if new_item == 0

                    curr_buffer{numel(curr_buffer)+1} = curr_subfeature;

                end

            end
        end

        if i == 1

            response_based_entropy(i) = start_entropy;

            items_left = numel(total_rule_list) - numel(curr_buffer);

        else

            items_left = numel(total_rule_list) - numel(curr_buffer);

            curr_prob = 1 / items_left;
            curr_prob_distr = [];
            curr_prob_distr(1:items_left) = curr_prob; %defines the probability distribution on i-th trial


            response_based_entropy(i) = -sum(curr_prob_distr.*(log2(curr_prob_distr))); %calculated the Shannon entropy on i-th trial based on probability distribution defined in line 104

        end


    end

end
