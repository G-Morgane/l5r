import type { PersonnageRow } from '~/utils/types'

export const usePersonnageActif = () => {
  return useState<PersonnageRow | null>('personnageActif', () => null)
}
