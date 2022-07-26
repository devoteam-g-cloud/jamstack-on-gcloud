const fetch = require("node-fetch");
require('dotenv').config();

// function to get blogposts
async function getAllBlogposts() {
  let blogposts = [];

  // make queries until makeNewQuery is set to false
  try {
    // initiate fetch
    const data = await fetch(process.env.API_URL, {
      method: "POST",
      headers: {
        "Content-Type": "application/json",
        Accept: "application/json",
      },
      body: JSON.stringify({
        query: `query {
          posts {
            data {
              id
              attributes {
                title
                content
                date
                author
                slug
              }
            }
          }
        }`,
      }),
    });

    // store the JSON response when promise resolves
    const response = await data.json();

    // handle CMS errors
    if (response.errors) {
      let errors = response.errors;
      errors.map((error) => {
        console.log(error.message);
      });
      throw new Error("Houston... We have a CMS problem");
    }

    // update blogpost array with the data from the JSON response
    blogposts = blogposts.concat(response.data.posts.data);
  } catch (error) {
    throw new Error(error);
  }

  console.log(blogposts)

  // format blogposts objects
  const blogpostsFormatted = blogposts.map((item) => {
    return {
      id: item.id,
      title: item.attributes.title,
      slug: item.attributes.slug,
      content: item.attributes.content,
      author: item.attributes.author,
      date: item.attributes.date       
    };
  });

  // return formatted blogposts
  return blogpostsFormatted;
}

// export for 11ty
module.exports = getAllBlogposts;