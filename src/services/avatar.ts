import { Avatar } from "../types/avatar";
import avatars from "../data/avatar.json";
import aliases from "../data/alias.json";

const AvatarService = {
  listAllAvatars(): Avatar[] {
    return avatars.slice();
  },

  listAllAliases(): string[] {
    return aliases.slice();
  },
};

export default AvatarService;
