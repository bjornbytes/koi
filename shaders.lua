Dirt = {}

function Dirt.load()
    save_d = love.graphics.newPixelEffect [[
        vec4 effect(vec4 colour, Image fluid, vec2 grid, vec2 screen)
        {
            vec4 ec = Texel(fluid, grid);
            return vec4(ec.r, 0.0, 0.0, 1.0);
        }
    ]]

    save_u = love.graphics.newPixelEffect [[
        vec4 effect(vec4 colour, Image fluid, vec2 grid, vec2 screen)
        {
            vec4 ec = Texel(fluid, grid);
            return vec4(0.0, ec.r, 0.0, 1.0);
        }
    ]]

    save_v = love.graphics.newPixelEffect [[
        vec4 effect(vec4 colour, Image fluid, vec2 grid, vec2 screen)
        {
            vec4 ec = Texel(fluid, grid);
            return vec4(0.0, 0.0, ec.r, 1.0);
        }
    ]]

    copy_u = love.graphics.newPixelEffect [[
        vec4 effect(vec4 colour, Image fluid, vec2 grid, vec2 screen)
        {
            vec4 ec = Texel(fluid, grid);
            return vec4(ec.g, ec.g, ec.b, 1.0);
        }
    ]]

    copy_v = love.graphics.newPixelEffect [[
        vec4 effect(vec4 colour, Image fluid, vec2 grid, vec2 screen)
        {
            vec4 ec = Texel(fluid, grid);
            return vec4(ec.b, ec.g, ec.b, 1.0);
        }
    ]]

    swap_d_u = love.graphics.newPixelEffect [[
        vec4 effect(vec4 colour, Image fluid, vec2 grid, vec2 screen)
        {
            vec4 ec = Texel(fluid, grid);
            return vec4(ec.g, ec.r, ec.b, 1.0);
        }
    ]]

    swap_d_v = love.graphics.newPixelEffect [[
        vec4 effect(vec4 colour, Image fluid, vec2 grid, vec2 screen)
        {
            vec4 ec = Texel(fluid, grid);
            return vec4(ec.b, ec.g, ec.r, 1.0);
        }
    ]]

    diffuse_copy = love.graphics.newPixelEffect [[
        vec4 effect(vec4 colour, Image fluid, vec2 grid, vec2 screen)
        {
            vec4 ec = Texel(fluid, grid);
            ec.g = ec.r;

            return ec;
        }
    ]]

    diffuse = love.graphics.newPixelEffect [[
        extern number size; 
        extern number sx;
        extern number sy;
        extern number dt;
        extern number diffusion;

        vec4 effect(vec4 colour, Image fluid, vec2 grid, vec2 screen)
        {
            number a = dt * diffusion * size * size;

            vec4 ec = Texel(fluid, vec2(grid.x   , grid.y   ));
            vec4 er = Texel(fluid, vec2(grid.x+sx, grid.y   ));
            vec4 ed = Texel(fluid, vec2(grid.x   , grid.y+sy));
            vec4 el = Texel(fluid, vec2(grid.x-sx, grid.y   ));
            vec4 eu = Texel(fluid, vec2(grid.x   , grid.y-sy));

            number neighbours = er.r + ed.r + el.r + eu.r;
            ec.r = (ec.g + neighbours * a) / (1 + 4*a);

            return ec;
        }
    ]]

    diffuse_post1 = love.graphics.newPixelEffect [[
        vec4 effect(vec4 colour, Image fluid, vec2 grid, vec2 screen)
        {
            vec4 ec = Texel(fluid, grid);

            return vec4(ec.r, 0, ec.b, 1.0);
        }
    ]]

    diffuse_post2 = love.graphics.newPixelEffect [[
        vec4 effect(vec4 colour, Image fluid, vec2 grid, vec2 screen)
        {
            vec4 ec = Texel(fluid, grid);
            return vec4(0.0, ec.g, 0.0, 1.0);
        }
    ]]

    advect = love.graphics.newPixelEffect [[
        extern number size;
        extern number dt;
        extern number inv_size;
        extern number correction;

        vec4 effect(vec4 colour, Image fluid, vec2 grid, vec2 screen)
        {
            number dt0 = dt * size;

            number i = grid.x * size;
            number j = grid.y * size;

            vec4 ec = Texel(fluid, grid);

            // backtrace velocity to find the source of value
            number x = i - dt0 * (ec.g - 0.5) * 0.5;
            number y = j - dt0 * (ec.b - 0.5) * 0.5;

            // bound
            if (x < -0.5) x = -0.5; if (x > size - 0.5) x = size - 0.5;
            if (y < -0.5) y = -0.5; if (y > size - 0.5) y = size - 0.5;

            // find neighbouring cells
            number i0 = floor(x); number i1 = i0 + 1;
            number j0 = floor(y); number j1 = j0 + 1;

            // distances from each each along the axes give the
            // interpolation factors
            number s1 = x - i0; number s0 = 1 - s1;
            number t1 = y - j0; number t0 = 1 - t1;

            // retrieve the neighbouring values (for velocities this needs
            // a correction constant [0, 1] => [-0.5, 0.5])
            number c = correction * 0.5;
            number d00 = Texel(fluid, vec2(i0, j0) * inv_size).r - c;
            number d01 = Texel(fluid, vec2(i0, j1) * inv_size).r - c;
            number d11 = Texel(fluid, vec2(i1, j1) * inv_size).r - c;
            number d10 = Texel(fluid, vec2(i1, j0) * inv_size).r - c;

            // the resulting value is a bilinear interpolation of the
            // neighbour values (for velocities this needs correction
            // again [-0.5, 0.5] => [0, 1]
            ec.r = s0*(t0*d00 + t1*d01)
                 + s1*(t0*d10 + t1*d11)
                 + c;

            return ec;
        }
    ]]

    project_pre = love.graphics.newPixelEffect [[
        extern number size;
        extern number inv_size;

        vec4 effect(vec4 colour, Image fluid, vec2 grid, vec2 screen)
        {
            number i = floor(grid.x * size);
            number j = floor(grid.y * size);

            number pl = Texel(fluid, vec2(i-1, j  ) * inv_size).g;
            number pr = Texel(fluid, vec2(i+1, j  ) * inv_size).g;
            number pu = Texel(fluid, vec2(i  , j-1) * inv_size).b;
            number pd = Texel(fluid, vec2(i  , j+1) * inv_size).b;

            number div = -0.5 * ((pr - pl) + (pd - pu)) * inv_size;

            number g = div * size * 0.5 + 0.5;

            return vec4(0.0, div, 0.0, 1.0);
        }
    ]]

    project = love.graphics.newPixelEffect [[
        extern number size;
        extern number inv_size;

        vec4 effect(vec4 colour, Image fluid, vec2 grid, vec2 screen)
        {
            number i = floor(grid.x * size);
            number j = floor(grid.y * size);

            number g = Texel(fluid, grid).g;
            number div = (g - 0.5) * inv_size * 2;

            number pl = Texel(fluid, vec2(i-1, j  ) * inv_size).r;
            number pr = Texel(fluid, vec2(i+1, j  ) * inv_size).r;
            number pu = Texel(fluid, vec2(i  , j-1) * inv_size).r;
            number pd = Texel(fluid, vec2(i  , j+1) * inv_size).r;

            number p = (pl + pr + pu + pd) * 0.25;

            return vec4(p, div, 0.0, 1.0);
        }
    ]]

    project_post = love.graphics.newPixelEffect [[
        extern number size;
        extern number inv_size;

        vec4 effect(vec4 colour, Image fluid, vec2 grid, vec2 screen)
        {
            number i = floor(grid.x * size);
            number j = floor(grid.y * size);

            number pl = Texel(fluid, vec2(i-1, j  ) * inv_size).r;
            number pr = Texel(fluid, vec2(i+1, j  ) * inv_size).r;
            number pu = Texel(fluid, vec2(i  , j-1) * inv_size).r;
            number pd = Texel(fluid, vec2(i  , j+1) * inv_size).r;

            number u = 0.5 * (pr - pl) * inv_size;
            number v = 0.5 * (pd - pu) * inv_size;

            return vec4(0.0, u + 0.5, v + 0.5, 1.0);
        }
    ]]

    draw = love.graphics.newPixelEffect [[
        vec4 effect(vec4 colour, Image fluid, vec2 grid, vec2 screen)
        {
            vec4 e00 = Texel(fluid, grid);

            return vec4(e00.r, 0.0, 0.0, 1.0);
        }
    ]]

    draw2 = love.graphics.newPixelEffect [[
        vec4 effect(vec4 colour, Image fluid, vec2 grid, vec2 screen)
        {
            vec4 e00 = Texel(fluid, grid);

            return vec4(e00.r, e00.g, e00.b, 1.0);
        }
    ]]

    input = love.graphics.newPixelEffect [[
        vec4 effect(vec4 colour, Image fluid, vec2 grid, vec2 screen)
        {
            vec4 e00 = Texel(fluid, grid);

            return vec4(e00.r, colour.g, e00.b, 1.0);
        }
    ]]

    diffuse:send("size", love.graphics.getWidth())
    diffuse:send("sx", 1 / love.graphics.getWidth())
    diffuse:send("sy", 1 / love.graphics.getHeight())

    advect:send("size", love.graphics.getWidth())
    advect:send("inv_size", 1 / love.graphics.getWidth())

    project_pre:send("size", love.graphics.getWidth())
    project_pre:send("inv_size", 1 / love.graphics.getWidth())

    project:send("size", love.graphics.getWidth())
    project:send("inv_size", 1 / love.graphics.getWidth())

    project_post:send("size", love.graphics.getWidth())
    project_post:send("inv_size", 1 / love.graphics.getWidth())

    fluid1 = love.graphics.newCanvas()
    fluid2 = love.graphics.newCanvas()
    backup = love.graphics.newCanvas()

    love.graphics.setBlendMode("premultiplied")
    fluid1:renderTo(function()
        --[[
        love.graphics.setColor(64, 96, 128, 255)
        love.graphics.rectangle("fill", 0, 0, 512, 512)

        love.graphics.setColor(0, 128, 64, 255)
        love.graphics.rectangle("fill", 0, 0, 512, 32)
        love.graphics.setColor(0, 128, 196, 255)
        love.graphics.rectangle("fill", 0, 512-32, 512, 32)
        love.graphics.setColor(0, 64, 128, 255)
        love.graphics.rectangle("fill", 0, 0, 32, 512)
        love.graphics.setColor(0, 196, 160, 255)
        love.graphics.rectangle("fill", 512-32, 0, 32, 512)
        ]]

        love.graphics.setColor(0, 128, 128, 255)
        love.graphics.rectangle("fill", 0, 0, 512, 512)
    end)

    timer = 0
    tstep = 0.01
    iters = 20
    visc = 0.1

    px, py = love.mouse.getPosition()
    cx, cy = love.mouse.getPosition()

    brush = love.graphics.newQuad(0, 0, 32, 32, love.graphics.getWidth(),
                                                love.graphics.getHeight())
end

function influence(output, dt)
    output:renderTo(function()
        love.graphics.setBlendMode("premultiplied")

        love.graphics.draw(input_stuff)
    end)    
end

function diffusion(output, input, dt, rate)
    output:clear()
    output:renderTo(function()
        love.graphics.setBlendMode("premultiplied")
        
        -- copy original densities to green slot
        love.graphics.setPixelEffect(diffuse_copy)
        love.graphics.draw(input)
        
        -- diffuse densities using originals and neighbours' current
        diffuse:send("dt", dt)
        diffuse:send("diffusion", rate)
        love.graphics.setPixelEffect(diffuse)
        for i=1,iters do
            love.graphics.draw(output)
        end

        -- clear green slot
        love.graphics.setBlendMode("premultiplied")
        love.graphics.setPixelEffect(diffuse_post1)
        love.graphics.draw(output)

        -- restore u velocities to green slot
        love.graphics.setBlendMode("additive")
        love.graphics.setPixelEffect(diffuse_post2)
        love.graphics.draw(input)
    end)
end

function advection(output, input, dt, correction)
    output:renderTo(function()
        love.graphics.setBlendMode("premultiplied")

        advect:send("dt", dt)
        advect:send("correction", correction or 0)
        love.graphics.setPixelEffect(advect)
        love.graphics.draw(input)
    end)
end

function projection(output, input)
    output:clear()
    output:renderTo(function()
        -- compute div values into green channel
        love.graphics.setBlendMode("premultiplied")
        love.graphics.setPixelEffect()--project_pre)
        love.graphics.draw(input)
        
        --[[
        -- iterate using originals and neighbours' current
        love.graphics.setPixelEffect(project)
        for i=1,iters do
            --love.graphics.draw(output)
        end

        -- copy velocities
        love.graphics.setBlendMode("premultiplied")
        love.graphics.setPixelEffect(project_post)
        love.graphics.draw(output)

        -- copy densities
        love.graphics.setBlendMode("additive")
        love.graphics.setPixelEffect(save_d)
        love.graphics.draw(input)
        --]]
    end)
end

function swap(output, shader)
    output:renderTo(function()
        love.graphics.setBlendMode("premultiplied")
        love.graphics.setPixelEffect(shader)
        love.graphics.draw(output)
    end)
end

function density(dt)
    --influence(fluid1, dt)
    diffusion(fluid2, fluid1, dt, visc)
    advection(fluid1, fluid2, dt)
end

function velocity_advect(output, input, dt)
    output:clear()
    -- pass densities through to output
    output:renderTo(function()
        love.graphics.setBlendMode("additive")
        love.graphics.setPixelEffect(save_d)
        love.graphics.draw(input)
    end)

    -- copy original u to density
    input:renderTo(function()
        love.graphics.setBlendMode("premultiplied")
        love.graphics.setPixelEffect(copy_u)
        love.graphics.draw(input)
    end)

    -- advect => density is new u
    advection(input, input, dt, 1)

    -- save new u to output
    output:renderTo(function()
        love.graphics.setBlendMode("additive")
        love.graphics.setPixelEffect(save_u)
        love.graphics.draw(input)
    end)

    -- copy original v to density
    input:renderTo(function()
        love.graphics.setBlendMode("premultiplied")
        love.graphics.setPixelEffect(copy_v)
        love.graphics.draw(input)
    end)

    -- advect => density is new v
    advection(input, input, dt, 1)

    -- save new v to output
    output:renderTo(function()
        love.graphics.setBlendMode("additive")
        love.graphics.setPixelEffect(save_v)
        love.graphics.draw(input)
    end)
end

function velocity(dt)
    --influence(fluid1, dt)

    swap(fluid1, swap_d_u)
    diffusion(fluid2, fluid1, dt, visc)
    swap(fluid1, swap_d_u)
    swap(fluid1, swap_d_v)
    diffusion(fluid2, fluid1, dt, visc)
    swap(fluid1, swap_d_v)

    projection(fluid2, fluid1)
    velocity_advect(fluid1, fluid2, dt)
    projection(fluid2, fluid1)

    fluid1, fluid2 = fluid2, fluid1
end

function Dirt.update(dt)
    dt = delta
    px, py = cx, cy
    cx, cy = love.mouse.getPosition()

    local dx, dy = cx - px, cy - py
    local angle = math.atan2(dy, dx)
    local d = math.sqrt(dx*dx + dy*dy)
    local vx, vy = math.cos(angle), -math.sin(angle)
    local xblend, yblend

    if vx >= 0 then xblend = "additive" else xblend = "subtractive" end
    if vy >= 0 then yblend = "additive" else yblend = "subtractive" end

    if love.mouse.isDown("l") then
        fluid1:renderTo(function()
            love.graphics.setBlendMode("additive")
            love.graphics.setColor(255, 0, 0, 255)
            love.graphics.circle("fill", cx, cy, d, 32)
            ----[[
            love.graphics.setLineWidth(10)
            love.graphics.setBlendMode(xblend)
            love.graphics.setColor(0, 128*vx, 0, 255)
            love.graphics.line(px, py, cx, cy)
            love.graphics.setBlendMode(yblend)
            love.graphics.setColor(0, 0, 128*vy, 255)
            love.graphics.line(px, py, cx, cy)
            love.graphics.setLineWidth(1)
            --]]
        end)
    end

    if love.mouse.isDown("r") then
        fluid1:renderTo(function()
            love.graphics.setLineWidth(10)
            love.graphics.setBlendMode(xblend)
            love.graphics.setColor(0, 128*vx, 0, 255)
            love.graphics.line(px, py, cx, cy)
            love.graphics.setBlendMode(yblend)
            love.graphics.setColor(0, 0, 128*vy, 255)
            love.graphics.line(px, py, cx, cy)
            love.graphics.setLineWidth(1)
        end)
    end
    --[[
    fluid1:renderTo(function()
        love.graphics.setBlendMode("subtractive")
        love.graphics.setColor(8, 0, 0, 255)
        love.graphics.rectangle("fill", 236, 236, 40, 40)

        love.graphics.setBlendMode("additive")
        love.graphics.setColor(255, 128, 128, 255)
        love.graphics.rectangle("line", 0, 0, 512, 512)
    end)
    --]]

    love.graphics.setBlendMode("alpha")
    love.graphics.setColor(255, 255, 255, 255)

    if timer < tstep then
        timer = timer + dt
    else
        timer = timer - tstep
        velocity(tstep)
        density(tstep)
    end
end

function Dirt.draw(something)
    love.graphics.setColor(255, 255, 255, 255)
    table.print(draw2)
    love.graphics.setPixelEffect(draw2)
    
    love.graphics.draw(something, 0, 0)

    love.graphics.setPixelEffect()
    love.graphics.setBlendMode("alpha")
end

function Dirt.keypressed(key)
    if key == " " then
        draw, draw2 = draw2, draw
    elseif key == "-" then
        visc = visc * 0.5
    elseif key == "=" then
        visc = visc * 2
    end

    visc = math.min(visc, 10)
    visc = math.max(visc, 0.001)
end

function Dirt.mousepressed(x, y, button)
    if button == "wd" then
        visc = visc * 0.5
    elseif button == "wu" then
        visc = visc * 2
    end

    visc = math.min(visc, 10)
    visc = math.max(visc, 0.001)
end

