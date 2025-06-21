import { ajax } from "discourse/lib/ajax";

/**
 * Fetches detailed user data using a Data Explorer query.
 * 
 * Query 11 returns users with columns: username, name, title, bio_cooked
 * Query can be found at: https://community.ankihub.net/admin/plugins/explorer/queries/11
 *
 * @param {Ember.Component} component - The component instance managing state.
 * @param {number} queryId - The ID of the Data Explorer query to run (should be 11).
 * @param {string} groupName - The name of the group to filter users by.
 * @param {string} userType - A string for logging/debugging purposes.
 * @returns {Promise<Array<Object>>} A promise that resolves to an array of user objects with properties: username, name, title, bio_cooked.
 */
export async function fetchDetailedUsers(component, queryId, groupName, userType) {
  if (component.isLoading) {
    return [];
  }

  component.isLoading = true;

  try {
    // Make a single API call to the Data Explorer endpoint
    const response = await ajax(`/admin/plugins/explorer/queries/${queryId}/run`, {
      method: "POST",
      data: {
        params: JSON.stringify({ group_name: groupName }),
      },
    });

    if (response.success && response.rows) {
      // Map the column names to the row data to create an array of objects
      const columns = response.columns; // ["username", "name", "title", "bio_cooked"]
      const detailedUserData = response.rows.map((row) => {
        const userObject = {};
        columns.forEach((col, index) => {
          userObject[col] = row[index];
        });
        return userObject;
      });

      // If the component hasn't been destroyed while we were loading
      return component.isDestroying ? [] : detailedUserData;
    } else {
      // Handle cases where the query ran but failed
      console.error(`[${userType}Wrapper] Data Explorer query failed:`, response.errors);
      return [];
    }
  } catch (error) {
    console.error(`[${userType}Wrapper] Error fetching data via Data Explorer:`, error);
    return []; // Return an empty array on failure
  } finally {
    if (!component.isDestroying) {
      component.isLoading = false;
    }
  }
}