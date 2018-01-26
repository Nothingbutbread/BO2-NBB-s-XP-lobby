Forge_Spawn_Object()
{
	level.spawnedforgeentities[level.spawnedforgeentities.size] = spawnEntity(model, origin, angle);
}
spawnEntity(model, origin, angle)
{
	entity = spawn("script_model", origin);
    entity.angles = angle;
    entity setModel(model);
    return entity;
}


