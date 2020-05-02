
function [random_response_based_entropy] = get_random_response_based_entropy_v2(trial_presentations)

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

random_response_based_entropy = zeros(1, size(trial_presentations, 1));


columns_arrow_keys = {'left'; 'down'; 'right'; 'up'};

for i = 1:size(trial_presentations, 1)

    if min(random_response_based_entropy) >= 0


        for ii = 1:4

            curr_trial = trial_presentations{i, ii}(1:3);

            for j = 1:numel(curr_trial)

                curr_trial_all(ii).bmp{j} = sprintf('%s%d', curr_trial(j), j);

            end

        end


        r = randi([1, 4], 1, 1);

        curr_chosen_card = curr_trial_all(r).bmp; %random choice of card on each trial

        %%


        if i == 1

            for z = 1:numel(curr_chosen_card)


                curr_buffer{z} = sprintf('%s%d', curr_chosen_card{z}); %on the first trial (i == 1), all 3 features from randomly selected card are added to buffer.
                %as the buffer is initially empty, no need to check if they are
                %already in the buffer

            end


        else %else this loop checks for each rule from the current card if it's already in the buffer. if not, it gets added.

            for iii = 1:numel(curr_chosen_card)


                subfeature{iii} = sprintf('%s%d', curr_chosen_card{iii});

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

            random_response_based_entropy(i) = start_entropy;

            items_left = numel(total_rule_list) - numel(curr_buffer);

        else


            items_left = numel(total_rule_list) - numel(curr_buffer); %calculates the number of remaining rules


            curr_prob = 1 / items_left;
            curr_prob_distr = [];
            curr_prob_distr(1:items_left) = curr_prob; %creates the probability distribution of remaining rules


            random_response_based_entropy(i) = -sum(curr_prob_distr.*(log2(curr_prob_distr))); %calculates the Shannon entropy on i-th trial


        end


    end

end
%
