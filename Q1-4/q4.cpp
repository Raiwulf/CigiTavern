//To fix the memory leak issue in the addItemToPlayer method, We need to be sure that any dynamically allocated memory (Player object) is properly managed and deallocated. If we fail at any step, we need to Dispose player object.

void Game::addItemToPlayer(const std::string& recipient, uint16_t itemId)
{
    Player* player = g_game.getPlayerByName(recipient);

    if (!player) {
        player = new Player(nullptr);
        if (!IOLoginData::loadPlayerByName(player, recipient)) {
            // Dispose player on player load fail
            delete player;
            return;
        }
    }

    Item* item = Item::CreateItem(itemId);
    if (!item) {
        // Dispose player on item creation fail
        delete player;
        return;
    }

    g_game.internalAddItem(player->getInbox(), item, INDEX_WHEREEVER, FLAG_NOLIMIT);

    if (player->isOffline()) {
        IOLoginData::savePlayer(player);
    }

    // Dispose player
    delete player;
}