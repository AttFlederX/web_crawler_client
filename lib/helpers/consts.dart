const String apiUrl = 'https://localhost:5001/graphql';
const String getNewsItemsQuery = """
query{
  allNewsItems {
    id,
    title,
    shortContent,
    category,
    url,
    source,
    added
  }
}
""";

const String worldCategoryName = 'world';
const String usNewsCategoryName = 'us-news';
const String politicsCategoryName = 'politics';
