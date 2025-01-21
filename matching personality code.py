import numpy as np

def calculate_personality_score(user_traits, match_traits, weights=None):
    """
    Calculate personality compatibility using weighted Euclidean distance.

    :param user_traits: List of user personality traits (e.g., [4, 3, 5, 2, 1])
    :param match_traits: List of match personality traits
    :param weights: List of weights for each trait (optional, default = equal weights)
    :return: Compatibility score (higher is better)
    """
    user_traits = np.array(user_traits)
    match_traits = np.array(match_traits)

    if weights is None:
        weights = np.ones_like(user_traits)
    else:
        weights = np.array(weights)

    # Weighted Euclidean distance (lower distance = higher compatibility)
    distance = np.sqrt(np.sum(weights * (user_traits - match_traits) ** 2))

    # Convert distance to score (inverse relationship)
    max_distance = np.sqrt(np.sum(weights * (5 - 1) ** 2))  # Assuming a 1-5 scale
    score = (max_distance - distance) / max_distance

    return score

def calculate_interest_score(user_interests, match_interests):
    """
    Calculate interests compatibility using Jaccard similarity.

    :param user_interests: Set of user interests (e.g., {"music", "sports"})
    :param match_interests: Set of match interests
    :return: Compatibility score (0 to 1)
    """
    intersection = len(user_interests & match_interests)
    union = len(user_interests | match_interests)
    if union == 0:
        return 0
    return intersection / union

def calculate_total_score(personality_score, interest_score, w1=0.5, w2=0.5):
    """
    Combine personality and interest scores into a total score.

    :param personality_score: Compatibility score for personality (0 to 1)
    :param interest_score: Compatibility score for interests (0 to 1)
    :param w1: Weight for personality score
    :param w2: Weight for interest score
    :return: Total compatibility score (0 to 1)
    """
    return w1 * personality_score + w2 * interest_score

# Example usage
user_traits = [4, 3, 5, 2, 1]  # User's personality traits
match_traits = [3, 3, 4, 3, 2]  # Match's personality traits
weights = [1, 1, 1, 1, 1]  # Equal weight for each trait

user_interests = {"music", "sports", "reading"}
match_interests = {"movies", "music", "reading"}

# Calculate scores
personality_score = calculate_personality_score(user_traits, match_traits, weights)
interest_score = calculate_interest_score(user_interests, match_interests)

total_score = calculate_total_score(personality_score, interest_score, w1=0.6, w2=0.4)

print("Personality Score:", personality_score)
print("Interest Score:", interest_score)
print("Total Compatibility Score:", total_score)
