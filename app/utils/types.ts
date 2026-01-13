// types/map.ts
export type MapLocationStatus = 'rumor' | 'known' | 'visited' | 'secret' | 'forbidden'
export type MapLocationType =
  | 'city' | 'village' | 'temple' | 'shrine'
  | 'port' | 'enemy_bastion' | 'other'

export type MapRow = {
  id: string
  name: string
  image_url: string | null
  grid_cols: number
  grid_rows: number
}

export type MapLocationRow = {
  id: string
  map_id: string
  name: string
  location_type: MapLocationType
  status: MapLocationStatus
  grid_col: number
  grid_row: number
  notes: string | null
  color: string | null
  icon: string | null
}

export type PersonnageRow = {
  id: string
  nom: string
  clan: string | null
  famille: string | null
  ecole: string | null
  rang: number
  statut: string
  avatar_url: string | null
  description: string | null
  experience_points: number
  reputation: number
  honneur: number
  gloire: number
  souillure: number
  initiative: number
  terre: number
  eau: number
  feu: number
  air: number
  vide: number
  constitution: number
  volonte: number
  force: number
  perception: number
  intelligence: number
  agilite: number
  intuition: number
  reflexes: number
  created_at: string
  updated_at: string
}
